package main

import (
	"flag"
	"io"
	"net/http"
	"os"
)

var target string = "http://localhost:42000/health"

func main() {
	flag.StringVar(&target, "target", target, "Target URL")
	flag.Parse()

	response, err := http.Get(target)
	if err != nil {
		panic(err)
	}
	defer func(Body io.ReadCloser) {
		err := Body.Close()
		if err != nil {
			panic(err)
		}
	}(response.Body)

	if response.StatusCode != http.StatusOK {
		os.Exit(1)
	}

	os.Exit(0)
}
