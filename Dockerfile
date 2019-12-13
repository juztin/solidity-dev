FROM ethereum/solc:0.5.14 as solc
FROM golang:1.13.5-alpine as builder

ARG GETH_VERSION=v1.9.9

COPY --from=solc /usr/bin/solc /usr/bin/solc

RUN apk --update add --virtual build-dependencies gcc libc-dev linux-headers git \
	&& mkdir -p $GOPATH/src/github.com/ethereum \
	&& cd $GOPATH/src/github.com/ethereum \
	&& git clone https://github.com/ethereum/go-ethereum.git \
	&& cd go-ethereum \
	&& git checkout tags/$GETH_VERSION \
	&& go install ./...

ENTRYPOINT ["/bin/sh"]
