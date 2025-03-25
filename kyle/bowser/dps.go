package main

import (
	"encoding/json"
	"errors"
	"io"
	"io/fs"
	"log/slog"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

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
		fin, err := os.Open(filepath.Join("dps", r.FormValue("response")) + ".json")
		if err != nil {
			if errors.Is(err, fs.ErrNotExist) {
				http.Error(w, http.StatusText(404), 404)
			} else {
				http.Error(w, http.StatusText(500), 500)
			}
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
