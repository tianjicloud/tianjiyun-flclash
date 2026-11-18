package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestDecodeApprovalRejectsTrailingJSONAndUnknownFields(t *testing.T) {
	for _, input := range []string{`{"official_app":true} {}`, `{"official_app":true,"secret":"x"}`} {
		if _, err := decodeRequest([]byte(input)); err == nil {
			t.Fatalf("accepted ambiguous approval JSON %q", input)
		}
	}
}

func TestReadBoundedRequiresPrivateRegularApproval(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "approved.json")
	if err := os.WriteFile(path, []byte(`{"official_app":true}`), 0600); err != nil {
		t.Fatal(err)
	}
	if _, err := readBounded(path, 1024, true); err != nil {
		t.Fatal(err)
	}
	if err := os.Chmod(path, 0644); err != nil {
		t.Fatal(err)
	}
	if _, err := readBounded(path, 1024, true); err == nil {
		t.Fatal("accepted group-readable approval file")
	}
	if err := os.Remove(path); err != nil {
		t.Fatal(err)
	}
	if err := os.Symlink(filepath.Join(dir, "target"), path); err != nil {
		t.Fatal(err)
	}
	if _, err := readBounded(path, 1024, true); err == nil {
		t.Fatal("accepted approval symlink")
	}
}

func TestWriteCandidateUsesPrivatePermissionsAndAtomicContent(t *testing.T) {
	path := filepath.Join(t.TempDir(), "candidate.yaml")
	contents := []byte("proxies: []\n")
	if err := writeCandidate(path, contents); err != nil {
		t.Fatal(err)
	}
	actual, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	if string(actual) != string(contents) {
		t.Fatalf("candidate contents = %q", actual)
	}
	info, err := os.Stat(path)
	if err != nil {
		t.Fatal(err)
	}
	if info.Mode().Perm() != 0600 {
		t.Fatalf("candidate mode = %o", info.Mode().Perm())
	}
	if strings.Contains(string(actual), "token") {
		t.Fatal("test candidate unexpectedly contains credential text")
	}
}
