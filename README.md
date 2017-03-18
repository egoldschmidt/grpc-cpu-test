# grpc-cpu-test

Repro case for gRPC 1.2.0rc2 (Python) pegging to 100% CPU after serving one RPC. We witnessed this when using a Go client and Python server, so that's what I've recreated here, but I don't expect the client runtime to be the root cause.

See [Dockerfile](./Dockerfile) for environment setup and [run.sh](./run.sh) for commands executed within container.

To repro:

1. `./run_test.sh`
2. Watch a Docker container go to 100% CPU.

Demo: https://asciinema.org/a/107720
