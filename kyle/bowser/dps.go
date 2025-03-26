package main

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"io/fs"
	"log/slog"
	"net/http"
	"net/smtp"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"
)

var dpsMutex sync.Mutex

func dpsBackOffice(ctx context.Context) error {
	dpsMutex.Lock()
	defer dpsMutex.Unlock()
	glob, err := filepath.Glob("dps/*.json")
	if err != nil {
		slog.Error("back office", "error", err)
		return err
	}
	for _, g := range glob {
		slog.Info("dps backoffice", "response file", g)
		fin, err := os.Open(g)
		if err != nil {
			slog.Error("back office", "error", err)
			continue
		}
		m := map[string]string{}
		err = json.NewDecoder(fin).Decode(&m)
		fin.Close()
		if err != nil {
			slog.Error("back office", "error", err)
			continue
		}
		event, err := time.Parse("01/02/2006", m["date"])
		if err != nil {
			slog.Error("back office", "error", err)
			continue
		}
		if time.Now().Before(event.Add(24 * time.Hour)) {
			continue
		}
		slog.Info("sending email", "payload", m)
		host := "relay.boisestate.edu:25"
		to := []string{m["email"]}
		from := m["from"]
		title := m["title"]
		subject := "Survey Followup for " + title

		body := []byte(m["followup"] + "?response=" + m["response"])

		var buf bytes.Buffer

		fmt.Fprintf(&buf, "To: %s\r\n", strings.Join(to, ", "))
		fmt.Fprintf(&buf, "From: %s\r\n", from)
		//fmt.Fprintf(&buf, "Cc: %s\r\n", strings.Join(cc, ","))
		fmt.Fprintf(&buf, "Reply-To: %s\r\n", from)
		fmt.Fprintf(&buf, "Subject: %s\r\n", subject)
		fmt.Fprintf(&buf, "\r\n")

		fmt.Fprintf(&buf, "This is a followup survey for the event %s:\n\n%s\n", title, body)

		if err := smtp.SendMail(host, nil, from, to, buf.Bytes()); err != nil {
			return err
		}
		if os.Getenv("DPS_QUALTRICS_KEEP") == "1" {
			slog.Info("dps survey keeping file", "file", g)
		} else {
			if err := os.Remove(g); err != nil {
				slog.Error("back office", "error", err)
			}
		}
	}
	return nil
}

func dpsSurveyHandler(w http.ResponseWriter, r *http.Request) {
	dpsApiKeyOnce.Do(func() {
		payload, err := os.ReadFile("key.txt")
		if err != nil {
			panic("failed to read key file (key.txt)")
		}
		dpsApiKey = strings.TrimSpace(string(payload))
		if dpsApiKey == "" {
			panic("failed to read key file (key.txt)")
		}
		go func() {
			// default tick is one hour, set DPS_QUALTRICS_TICK to override
			// that value, for example DPS_QUALTRICS_TICK=10s to debug
			tick := time.Hour
			if v := os.Getenv("DPS_QUALTRICS_TICK"); v != "" {
				var err error
				tick, err = time.ParseDuration(v)
				if err != nil {
					panic("failed to parse duration for dps tick: " + v)
				}
			}
			t := time.NewTicker(tick)
			for {
				<-t.C
				if err := dpsBackOffice(context.TODO()); err != nil {
					slog.Error("sending failure", "error", err)
				}
			}
		}()
	})
	if key := r.Header.Get("key"); key != dpsApiKey {
		slog.Error("dpssurvey", "invalid key", key)
		http.Error(w, http.StatusText(401), 401)
		return
	}
	switch r.Method {
	case http.MethodPost:
		m := map[string]string{}
		err := json.NewDecoder(r.Body).Decode(&m)
		if err != nil {
			slog.Error("dpssurvey", "error", err)
			http.Error(w, http.StatusText(500), 500)
			return
		}
		slog.Info("dpssurvey", "event", m)
		fout, err := os.Create(filepath.Join("dps", m["response"]) + ".json")
		if err != nil {
			slog.Error("dpssurvey", "error", err)
			http.Error(w, http.StatusText(500), 500)
			return
		}
		defer fout.Close()
		err = json.NewEncoder(fout).Encode(m)
		if err != nil {
			slog.Error("dpssurvey", "error", err)
			http.Error(w, http.StatusText(500), 500)
			return
		}
	case http.MethodGet:
		p := filepath.Join("dps", r.FormValue("response")) + ".json"
		slog.Info("dps survey", "get", p)
		fin, err := os.Open(p)
		if err != nil {
			if errors.Is(err, fs.ErrNotExist) {
				http.Error(w, http.StatusText(404), 404)
			} else {
				http.Error(w, http.StatusText(500), 500)
			}
			slog.Error("dps survey", "error", err)
			return
		}
		defer fin.Close()
		w.Header().Set("Content-Type", "application/json")
		io.Copy(w, fin)
	default:
		http.Error(w, http.StatusText(405), 405)
		return
	}
}
