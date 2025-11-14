FROM rust:1-slim-bookworm AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install -y \
  libssl-dev \
  pkg-config \
  fontconfig \
  fonts-liberation && \
  rm -rf /var/lib/apt/lists/*

COPY watermark.png .
COPY divedb_core divedb_core
COPY divedb_macro divedb_macro

COPY Cargo.toml .
COPY Cargo.lock .
COPY templates templates
COPY src src

RUN \
  --mount=type=cache,target=/usr/local/cargo/registry \
  --mount=type=cache,target=/usr/local/cargo/git \
  --mount=type=cache,target=/target \
  cargo build --release && cp target/release/divedb /divedb

FROM gcr.io/distroless/cc-debian12
COPY --from=builder /divedb /usr/local/bin/divedb
COPY --from=builder /usr/share/fonts /usr/share/fonts
COPY --from=builder /etc/fonts /etc/fonts

EXPOSE 3333

CMD ["divedb"]
