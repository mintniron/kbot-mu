APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=mintniron
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux # darwin windows
TARGETARCH=amd64 # amd64 arm64
#VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
#TARGETOS=$(shell uname -s | tr "[:upper:]" "[:lower:]")
#TARGETARH=${shell uname -m}

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARH=${TARGETARH} go build -v -o kbot -ldflags "-X="github.com/mintniron/kbot/cmd.appVersion=${VERSION}

linux:
	CGO_ENABLED=0 GOOS=linux GOARH=amd64 go build -v -o kbot -ldflags "-X="github.com/mintniron/kbot/cmd.appVersion=${VERSION}

macos:
	CGO_ENABLED=0 GOOS=darwin GOARH=amd64 go build -v -o kbot -ldflags "-X="github.com/mintniron/kbot/cmd.appVersion=${VERSION}

windows:
	CGO_ENABLED=0 GOOS=windows GOARH=amd64 go build -v -o kbot.exe -ldflags "-X="github.com/mintniron/kbot/cmd.appVersion=${VERSION}

arm:
	CGO_ENABLED=0 GOOS=darwin GOARH=arm64 go build -v -o kbot -ldflags "-X="github.com/mintniron/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARH}

clean:
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARH}
