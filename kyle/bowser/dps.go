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

var dpsApiKey = ""

func init() {
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
			slog.Info("dps back office overriding tick")
		}
		slog.Info("dps back office", "tick", tick)
		t := time.NewTicker(tick)
		for {
			slog.Info("dps back office", "time", time.Now())
			<-t.C
			if err := dpsBackOffice(context.TODO()); err != nil {
				slog.Error("sending failure", "error", err)
			}
		}
	}()
}

var dpsMutex sync.Mutex

func dpsBackOffice(ctx context.Context) error {
	_ = ctx
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
		to := []string{m["to"]}
		from := m["from"]
		subject := m["subject"]
		body := m["body"]

		var buf bytes.Buffer

		fmt.Fprintf(&buf, "To: %s\r\n", strings.Join(to, ", "))
		fmt.Fprintf(&buf, "From: %s\r\n", from)
		fmt.Fprintf(&buf, "Reply-To: %s\r\n", from)
		fmt.Fprintf(&buf, "Subject: %s\r\n", subject)
		fmt.Fprintf(&buf, "\r\n")

		fmt.Fprintf(&buf, body)

		if os.Getenv("DPS_QUALTRICS_DRYRUN") == "1" {
			slog.Info("dps survey dry run file", "file", g, "payload", m)
		} else {
			if err := smtp.SendMail(host, nil, from, to, buf.Bytes()); err != nil {
				return err
			}
			dst := filepath.Join("dps", "sent", filepath.Base(g))
			slog.Info("moving", "source", g, "destination", dst)
			if err := os.Rename(g, dst); err != nil {
				slog.Error("failed to move", "source", g, "destination", dst)
			}
		}
	}
	return nil
}

func dpsSurveyHandler(w http.ResponseWriter, r *http.Request) {
	if key := r.Header.Get("X-Auth-Token"); key != dpsApiKey {
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
		dpsMutex.Lock()
		defer dpsMutex.Unlock()
		p := filepath.Join("dps", "sent", r.FormValue("response")) + ".json"
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
