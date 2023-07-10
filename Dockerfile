#################################################################### Build image
FROM rust:1.70-slim-bullseye AS builder

RUN update-ca-certificates

# Create an unprivileged appuser:
ENV USER=hello
ENV UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

WORKDIR /hello

COPY ./ .

RUN cargo build --release

################################################################## Runtime image
FROM gcr.io/distroless/cc

# Import appuser from builder:
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

WORKDIR /hello

COPY --from=builder /hello/target/release/hello ./

# Use an unprivileged appuser:
USER hello:hello

CMD ["/hello/hello"]
