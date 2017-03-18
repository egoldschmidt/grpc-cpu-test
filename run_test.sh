#!/bin/bash
# Main entrypoint.

docker build -t grpc-cpu-test .
docker run -ti --rm grpc-cpu-test
