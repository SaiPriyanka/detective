.PHONY: all
all: build test

ALL_PACKAGES=$(shell go list ./... | grep -v "vendor")

setup:
	mkdir -p $(GOPATH)/bin
	mkdir ./out
	go get -u github.com/golang/lint/golint

compile:
	go build -race ./...

build: compile fmt vet

fmt:
	go fmt ./...

vet:
	go vet ./...

lint:
	golint -set_exit_status $(ALL_PACKAGES)

test: fmt vet build
	ENVIRONMENT=test go test -race ./...

test-cover-html:
	@echo "mode: count" > coverage-all.out

	$(foreach pkg, $(ALL_PACKAGES),\
	ENVIRONMENT=test go test -coverprofile=coverage.out -covermode=count $(pkg);\
	tail -n +2 coverage.out >> coverage-all.out;)
	go tool cover -html=coverage-all.out -o out/coverage.html