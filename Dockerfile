FROM debian:jessie-slim
ARG version
LABEL version ${version}
LABEL description "Hello, Rust!"
LABEL maintainer "Marc Carre <carre.marc@gmail.com>"
COPY ./target/release/hello-rust /usr/bin/hello-rust
ENTRYPOINT ["/usr/bin/hello-rust"]
