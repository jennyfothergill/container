package main

import (
	"crypto/tls"
	"flag"
	"log"
	"log/slog"
	"net/http"
	"net/http/httputil"
	"net/url"

	"golang.org/x/crypto/acme/autocert"
)

// bowser is a simple reverse proxy to handle a few
// podman containers running shiny servers on
// bowser.boisestate.edu.
func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	flagAddr := flag.String("addr", ":https", "address to listen on")
	flag.Parse()
	// greeco is a shiny server run by Mark Schmitz
	target := url.URL{
		Scheme: "http",
		Host:   "localhost:8888",
	}
	greeco := httputil.NewSingleHostReverseProxy(&target)
	mux := http.NewServeMux()
	mux.Handle("/shiny/greeco/", http.StripPrefix("/shiny/greeco", greeco))
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		slog.Info("route", "path", r.URL.Path)
		mux.ServeHTTP(w, r)
	})

	// dps survey handles some qualtrics data
	mux.HandleFunc("/dpssurvey/", dpsSurveyHandler)

	srv := http.Server{
		Addr:    *flagAddr,
		Handler: handler,
	}
	slog.Info("listen", "address", *flagAddr)
	if *flagAddr != ":https" && *flagAddr != ":443" {
		log.Fatal(srv.ListenAndServe())
	}
	m := &autocert.Manager{
		Cache:      autocert.DirCache("acme"),
		Prompt:     autocert.AcceptTOS,
		HostPolicy: autocert.HostWhitelist("bowser.boisestate.edu"),
		Email:      "kyleshannon@boisestate.edu",
	}
	go func() {
		log.Fatal(http.ListenAndServe(":http", m.HTTPHandler(nil)))
	}()
	srv.TLSConfig = m.TLSConfig()
	srv.TLSConfig.MinVersion = tls.VersionTLS12
	srv.TLSConfig.CipherSuites = []uint16{
		tls.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
		tls.TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
		tls.TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256,
		tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
		tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
		tls.TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256,
	}
	log.Fatal(srv.ListenAndServeTLS("", ""))
}
