# syntax=docker/dockerfile:1.2
FROM rustlang/rust:nightly AS chef

RUN apt-get update && \
    apt-get install -y clang openssh-client git && \
    rm -rf /var/lib/apt/lists/*

RUN cargo install cargo-chef

WORKDIR /gha-tests

FROM chef AS planner

ENV CARGO_NET_GIT_FETCH_WITH_CLI=true

COPY src ./src
COPY Cargo.* .

RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder

COPY --from=planner /gha-tests/recipe.json recipe.json

# Build dependencies only, these remained cached
RUN --mount=type=ssh cargo chef cook --release --recipe-path recipe.json

# Optional build flags
ARG BUILD_FLAGS=""
COPY src ./src
COPY Cargo.* .
RUN cargo build --release $BUILD_FLAGS

FROM ubuntu:24.04
WORKDIR /usr/local/bin
LABEL org.opencontainers.image.source=https://github.com/phylaxsystems/gha-tests
LABEL org.opencontainers.image.licenses="MIT OR Apache-2.0"

# Filled by docker buildx
ARG TARGETARCH

COPY --from=builder /gha-tests/target/release/gha-tests /usr/local/bin/gha-tests

ENTRYPOINT ["/usr/local/bin/gha-tests"]
