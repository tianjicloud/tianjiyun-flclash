package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"path/filepath"

	"core/tianji"
)

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func run() error {
	sourcePath := flag.String("source", "", "original YAML subscription")
	requestPath := flag.String("approval", "", "offline approved mapping JSON")
	outputPath := flag.String("output", "", "candidate output path")
	flag.Parse()
	if *sourcePath == "" || *requestPath == "" || *outputPath == "" {
		return errors.New("usage: tianji-subscription-candidate -source old.yaml -approval approved.json -output candidate.yaml")
	}
	source, err := readBounded(*sourcePath, 4<<20, false)
	if err != nil {
		return fmt.Errorf("read source subscription")
	}
	data, err := readBounded(*requestPath, 1<<20, true)
	if err != nil {
		return fmt.Errorf("approval file must be a regular 0600 file")
	}
	request, err := decodeRequest(data)
	if err != nil {
		return err
	}
	candidate, converted, err := tianji.ConvertSubscriptionCandidate(source, request)
	if err != nil {
		return err
	}
	if err = writeCandidate(*outputPath, candidate); err != nil {
		return err
	}
	if converted {
		fmt.Fprintln(os.Stderr, "wrote Tianji candidate; this is not a production subscription")
	} else {
		fmt.Fprintln(os.Stderr, "wrote unchanged subscription for a client without explicit Tianji opt-in")
	}
	return nil
}

func decodeRequest(data []byte) (tianji.SubscriptionRequest, error) {
	var request tianji.SubscriptionRequest
	decoder := json.NewDecoder(bytes.NewReader(data))
	decoder.DisallowUnknownFields()
	if err := decoder.Decode(&request); err != nil {
		return request, errors.New("invalid approval JSON")
	}
	var extra any
	if err := decoder.Decode(&extra); err != io.EOF {
		return request, errors.New("approval JSON must contain exactly one object")
	}
	return request, nil
}

func readBounded(path string, limit int64, private bool) ([]byte, error) {
	info, err := os.Lstat(path)
	if err != nil {
		return nil, err
	}
	if !info.Mode().IsRegular() || info.Size() > limit {
		return nil, errors.New("invalid file")
	}
	if private && info.Mode().Perm()&0077 != 0 {
		return nil, errors.New("approval permissions must be 0600")
	}
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()
	opened, err := file.Stat()
	if err != nil || !os.SameFile(info, opened) || !opened.Mode().IsRegular() {
		return nil, errors.New("file changed while opening")
	}
	data, err := io.ReadAll(io.LimitReader(file, limit+1))
	if err != nil {
		return nil, err
	}
	if int64(len(data)) > limit {
		return nil, errors.New("file is too large")
	}
	return data, nil
}

func writeCandidate(path string, data []byte) error {
	dir := filepath.Dir(path)
	tmp, err := os.CreateTemp(dir, ".tianji-candidate-*")
	if err != nil {
		return fmt.Errorf("create candidate temp file: %w", err)
	}
	name := tmp.Name()
	defer os.Remove(name)
	if err = tmp.Chmod(0600); err == nil {
		_, err = tmp.Write(data)
	}
	if closeErr := tmp.Close(); err == nil {
		err = closeErr
	}
	if err != nil {
		return fmt.Errorf("write candidate: %w", err)
	}
	if err = os.Rename(name, path); err != nil {
		return fmt.Errorf("publish candidate file: %w", err)
	}
	return nil
}
