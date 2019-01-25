FROM ethereum/solc:0.5.2 as solc
FROM golang:1.11-alpine as builder

COPY --from=solc /usr/bin/solc /usr/bin/solc

RUN apk --update add --virtual build-dependencies gcc libc-dev linux-headers git \
	&& mkdir -p $GOPATH/src/github.com/ethereum \
	&& cd $GOPATH/src/github.com/ethereum \
	&& git clone https://github.com/ethereum/go-ethereum.git \
	&& cd go-ethereum \
	&& git checkout tags/v1.8.21 \
	&& go install ./...
#	&& apk del build-dependencies

ENTRYPOINT ["/bin/sh"]