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

# Tag the image with OCI labels. See also: https://github.com/opencontainers/image-spec/blob/main/annotations.md
# "image.revision" and "image.created" change for every build, hence we run this as the last layer of the Docker image:
ARG BUILD_DATE
ARG REVISION
LABEL maintainer="Marc Carré <carre.marc@gmail.com>" \
    org.opencontainers.image.vendor="N/A" \
    org.opencontainers.image.title="rust-sample-project" \
    org.opencontainers.image.description="A sample dockerised Rust project" \
    org.opencontainers.image.url="https://github.com/marccarre/rust-sample-project" \
    org.opencontainers.image.source="git@github.com:marccarre/rust-sample-project.git" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.created="${BUILD_DATE}"
