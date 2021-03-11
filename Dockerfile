###
# Build Helm
###
FROM ghcr.io/rblaine95/golang:1.15-alpine AS builder

WORKDIR /opt/build

USER root

RUN apk upgrade --no-cache && \
    apk add --no-cache git openssh g++ cmake coreutils build-base bash shadow && \
    rm -rfv /var/cache/apk

COPY . .

RUN cd helm && make -j$(nproc)

###
# Copy from Builder
###
FROM ghcr.io/rblaine95/alpine:3.13

COPY --from=builder /opt/build/helm/bin/helm /usr/local/bin

RUN apk add --no-cache git openssh

ENTRYPOINT ["helm"]
CMD ["--help"]

