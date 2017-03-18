#!/bin/bash

set -e

# compile go protobufs

protoc --go_out=plugins=grpc:. *.proto

# start server

echo "Starting server..."

python3 server.py > /tmp/server.log 2>&1 &

# wait for it to be ready...

sleep 2

# rearrange files & start client

echo "Starting client..."

mkdir -p /gocode/src/github.com/evangoldschmidt/test/proto
mv hello.pb.go /gocode/src/github.com/evangoldschmidt/test/proto
mv client.go /gocode/src/github.com/evangoldschmidt/test
go run /gocode/src/github.com/evangoldschmidt/test/client.go > /tmp/client.log 2>&1 &

echo "Good to go!"

# tail logs

exec tail -f /tmp/server.log -f /tmp/client.log
