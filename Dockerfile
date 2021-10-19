FROM golang:1.17-alpine as geth
ARG GETH_VERSION=v1.10.10
RUN apk --update add --virtual build-dependencies gcc libc-dev linux-headers git upx \
	&& mkdir -p /go/src/github.com/ethereum \
	&& cd /go/src/github.com/ethereum \
	&& git clone https://github.com/ethereum/go-ethereum.git \
	&& cd go-ethereum \
	&& git checkout tags/$GETH_VERSION \
	&& go build -ldflags="-w -s" -o /go/bin/geth cmd/geth/*.go \
	&& upx -9 /go/bin/geth

FROM alpine
EXPOSE 8545/tcp
EXPOSE 8546/tcp
COPY --from=geth /go/bin/geth /bin/geth
ENTRYPOINT ["/bin/geth"]
