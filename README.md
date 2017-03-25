[![Build Status](https://travis-ci.org/marccarre/rust-sample-project.svg?branch=master)](https://travis-ci.org/marccarre/rust-sample-project)
[![Docker Pulls on Quay](https://quay.io/repository/marccarre/hello-rust/status "Docker Repository on Quay")](https://quay.io/repository/marccarre/hello-rust)
[![Docker Pulls on DockerHub](https://img.shields.io/docker/pulls/marccarre/hello-rust.svg?maxAge=604800)](https://hub.docker.com/r/marccarre/hello-rust/)

# rust-sample-project
A cloud-native Rust sample project leveraging containers for build & runtime.

### Features

- Only Docker is required, and optionally, `make`:
  - no need to install Rust, Cargo, etc. in order to set up the development environment;
  - we rely on the [rust-dev-env](https://github.com/marccarre/rust-docker-dev-env) Docker image for this.
- Targets:
  - `build`: compiles and links "debug" binary;
  - `~build`: continuously builds "debug" binary; change any source file & `cargo build` will automatically be triggered;
  - `build-release`: builds "release" binary & package it as a Docker container (required for `run` and `release` goals below);
  - `run`: runs the Docker container containing the "release" binary, as it would in production;
  - `release`: pushes the previously built Docker container to DockerHub and Quay.io;
  - `shell`: provide a shell inside the build container, for debugging purposes, ad-hoc tasks, etc.;
  - `clean`: delete all binaries & containers for this project.

### Examples

#### `build`: compiles and links "debug" binary

```
$ make
docker run -ti -v /home/marc/rust-sample-project/:/home/rust marccarre/rust-dev-env:latest cargo build
   Compiling hello-rust v1.0.0 (file:///home/rust)
    Finished dev [unoptimized + debuginfo] target(s) in 1.36 secs
```

#### `~build`: continuously builds "debug" binary -- educes insanity level & odds of RSI!!!

```
$ make ~build
docker run -ti -v /home/marc/rust-sample-project/:/home/rust marccarre/rust-dev-env:latest build-continuously.sh
Setting up watches.  Beware: since -r was given, this may take a while!
Watches established.
[2017-03-25 22:20:36] MODIFY on main.rs. Rebuilding now...
   Compiling hello-rust v1.0.0 (file:///home/rust)
    Finished dev [unoptimized + debuginfo] target(s) in 1.27 secs
[2017-03-25 22:20:38] MODIFY on main.rs. Rebuilding now...
   Compiling hello-rust v1.0.0 (file:///home/rust)
    Finished dev [unoptimized + debuginfo] target(s) in 1.13 secs
^C
```

#### `build-release`: builds "release" binary & package it as a Docker container

```
$ make build-release
docker run -ti -v /home/marc/rust-sample-project/:/home/rust marccarre/rust-dev-env:latest cargo build --release
    Finished release [optimized] target(s) in 0.0 secs
docker build \
    -t marccarre/hello-rust:latest \
    -t marccarre/hello-rust:1.0.0 \
    -t quay.io/marccarre/hello-rust:latest \
    -t quay.io/marccarre/hello-rust:1.0.0 \
    --build-arg=version=1.0.0 \
    /home/marc/rust-sample-project/
Sending build context to Docker daemon 7.184 MB
Step 1/7 : FROM debian:jessie-slim
 ---> aabe9b489bfd
Step 2/7 : ARG version
 ---> Using cache
 ---> f568f758f17d
Step 3/7 : LABEL version ${version}
 ---> Using cache
 ---> de3ed0ba9b5f
Step 4/7 : LABEL description "Hello, Rust!"
 ---> Using cache
 ---> 083a554a0d8e
Step 5/7 : LABEL maintainer "Marc Carre <carre.marc@gmail.com>"
 ---> Using cache
 ---> c3b41cc75d4a
Step 6/7 : COPY ./target/release/hello-rust /usr/bin/hello-rust
 ---> Using cache
 ---> a5a69e2f8012
Step 7/7 : ENTRYPOINT /usr/bin/hello-rust
 ---> Using cache
 ---> 291a2be67789
Successfully built 291a2be67789
```

#### `run`: runs the Docker container containing the "release" binary, as it would in production

```
$ make run
docker run -ti -v /home/marc/rust-sample-project/:/home/rust marccarre/rust-dev-env:latest cargo build --release
    Finished release [optimized] target(s) in 0.0 secs
docker build \
    -t marccarre/hello-rust:latest \
    -t marccarre/hello-rust:1.0.0 \
    -t quay.io/marccarre/hello-rust:latest \
    -t quay.io/marccarre/hello-rust:1.0.0 \
    --build-arg=version=1.0.0 \
    /home/marc/rust-sample-project/
Sending build context to Docker daemon 7.184 MB
Step 1/7 : FROM debian:jessie-slim
 ---> aabe9b489bfd
Step 2/7 : ARG version
 ---> Using cache
 ---> f568f758f17d
Step 3/7 : LABEL version ${version}
 ---> Using cache
 ---> de3ed0ba9b5f
Step 4/7 : LABEL description "Hello, Rust!"
 ---> Using cache
 ---> 083a554a0d8e
Step 5/7 : LABEL maintainer "Marc Carre <carre.marc@gmail.com>"
 ---> Using cache
 ---> c3b41cc75d4a
Step 6/7 : COPY ./target/release/hello-rust /usr/bin/hello-rust
 ---> Using cache
 ---> a5a69e2f8012
Step 7/7 : ENTRYPOINT /usr/bin/hello-rust
 ---> Using cache
 ---> 291a2be67789
Successfully built 291a2be67789
----------------------------------------
docker run marccarre/hello-rust:latest
Hello, Rust!
----------------------------------------
```

#### `release`: pushes the previously built Docker container to DockerHub and Quay.io

```
$ make release
docker run -ti -v /home/marc/rust-sample-project/:/home/rust marccarre/rust-dev-env:latest cargo build --release
    Finished release [optimized] target(s) in 0.0 secs
docker build \
    -t marccarre/hello-rust:latest \
    -t marccarre/hello-rust:1.0.0 \
    -t quay.io/marccarre/hello-rust:latest \
    -t quay.io/marccarre/hello-rust:1.0.0 \
    --build-arg=version=1.0.0 \
    /home/marc/rust-sample-project/
Sending build context to Docker daemon 7.184 MB
Step 1/7 : FROM debian:jessie-slim
 ---> aabe9b489bfd
Step 2/7 : ARG version
 ---> Using cache
 ---> f568f758f17d
Step 3/7 : LABEL version ${version}
 ---> Using cache
 ---> de3ed0ba9b5f
Step 4/7 : LABEL description "Hello, Rust!"
 ---> Using cache
 ---> 083a554a0d8e
Step 5/7 : LABEL maintainer "Marc Carre <carre.marc@gmail.com>"
 ---> Using cache
 ---> c3b41cc75d4a
Step 6/7 : COPY ./target/release/hello-rust /usr/bin/hello-rust
 ---> Using cache
 ---> a5a69e2f8012
Step 7/7 : ENTRYPOINT /usr/bin/hello-rust
 ---> Using cache
 ---> 291a2be67789
Successfully built 291a2be67789
docker push marccarre/hello-rust:latest
The push refers to a repository [docker.io/marccarre/hello-rust]
c49019410b5c: Pushed
cafb7d9a7d64: Mounted from marccarre/rust-dev-env
latest: digest: sha256:deff2eea38a202c6bbd7068dedf944b2dec5be0131f8d660ddd2c1dc65f966c1 size: 739
docker push marccarre/hello-rust:1.0.0
The push refers to a repository [docker.io/marccarre/hello-rust]
c49019410b5c: Layer already exists
cafb7d9a7d64: Layer already exists
1.0.0: digest: sha256:deff2eea38a202c6bbd7068dedf944b2dec5be0131f8d660ddd2c1dc65f966c1 size: 739
docker push quay.io/marccarre/hello-rust:latest
The push refers to a repository [quay.io/marccarre/hello-rust]
c49019410b5c: Pushed
cafb7d9a7d64: Pushed
latest: digest: sha256:402dcb957a6090a966f3fd740597144e7d9ad6f95b4dea0a282b3f7305362f6e size: 5259
docker push quay.io/marccarre/hello-rust:1.0.0
The push refers to a repository [quay.io/marccarre/hello-rust]
c49019410b5c: Layer already exists
cafb7d9a7d64: Layer already exists
1.0.0: digest: sha256:5eaefa7c112a205fe9f6537f7ed8d9c6b4c410b812bfb2315867cea6ea4ada51 size: 5258
```

#### `shell`: provide a shell inside the build container, for debugging purposes, ad-hoc tasks, etc.

```
$ make shell
docker run -ti -v /home/marc/rust-sample-project/:/home/rust marccarre/rust-dev-env:latest
root@763696c86093:/home/rust#
```

#### `clean`: delete all binaries & containers for this project (no binary, no users; no users, no drama!)

```
$ make clean
docker run -ti -v /home/marc/rust-sample-project/:/home/rust marccarre/rust-dev-env:latest cargo clean
docker rmi -f \
    marccarre/hello-rust:latest \
    marccarre/hello-rust:1.0.0 \
    quay.io/marccarre/hello-rust:latest \
    quay.io/marccarre/hello-rust:1.0.0
Untagged: marccarre/hello-rust:latest
Untagged: marccarre/hello-rust:1.0.0
Untagged: quay.io/marccarre/hello-rust:latest
Untagged: quay.io/marccarre/hello-rust:1.0.0
Deleted: sha256:ba6034bda1570e61453d39b0df515090a1d119a5212c47488b424448dfef51ec
Deleted: sha256:a54899cdd185d27359d8dc5c8b2737f009f0c07e2f916f402c58edc9e4fd201a
Deleted: sha256:13ec0a9cfea65f5d82031f3a52a188583f4c0754c62b32db42b2e3e98416c8cf
Deleted: sha256:d70b713c2e8080630468b794f4072733e004ae0273d56be0f73fce769791d779
Deleted: sha256:190aaeb2565cfff1ff39b6ac64c61bb6bf36021624b3f8575b5ed938d07429d2
Deleted: sha256:95705aeac8d4c8291914d67eaa0e81080e2750f80587b02f5236a8b540f4214c
```
