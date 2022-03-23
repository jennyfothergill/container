package main

import (
	"encoding/json"
	"log"
	"net/http"
)

func version(w http.ResponseWriter, r *http.Request) {
	type Version struct {
		Data struct {
			APIVersion string `json:"apiVersion"`
			Version    string `json:"version"`
		} `json:"data"`
	}
	v := Version{}
	v.Data.APIVersion = "v2.0.0-alpha.1"
	v.Data.Version = "v1.0.0"
	err := json.NewEncoder(w).Encode(v)
	if err != nil {
		log.Print(err)
	}
}

func main() {
	mux := &http.ServeMux{}
	mux.HandleFunc("/version", version)
	s := &http.Server{
		Addr:    ":8888",
		Handler: mux,
	}
	log.Fatal(s.ListenAndServe())
}
