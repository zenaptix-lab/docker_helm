###
# Build Helm
###
FROM quay.io/zenlab/golang:1.16-alpine AS builder

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
FROM quay.io/zenlab/alpine:3.14

COPY --from=builder /opt/build/helm/bin/helm /usr/local/bin

RUN apk add --no-cache git openssh

ENTRYPOINT ["helm"]
CMD ["--help"]
