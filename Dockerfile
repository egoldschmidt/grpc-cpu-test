FROM ubuntu:xenial

ENV GO_VERSION=1.8

ENV DEBIAN_FRONTEND noninteractive
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8

ENV GOROOT=/usr/local/go
ENV GOPATH=/gocode
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin:/anaconda/bin
ENV APP_DIR=/usr/src/app

# deps

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y openssl ca-certificates wget curl unzip bzip2 git \
    && apt-get clean && dpkg-reconfigure locales && locale-gen en_US.UTF-8 \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# python

RUN wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
    && bash miniconda.sh -b -p /anaconda \
    && conda install pip cython \
    && conda clean -tipsy \
    && rm miniconda.sh

# go

RUN wget https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz \
    && mkdir -p $GOPATH

# project

RUN go get google.golang.org/grpc
RUN go get -u github.com/golang/protobuf/proto github.com/golang/protobuf/protoc-gen-go

RUN wget https://github.com/google/protobuf/releases/download/v3.1.0/protoc-3.1.0-linux-x86_64.zip \
    && unzip protoc-3.1.0-linux-x86_64.zip \
    && mv bin/protoc /usr/bin/

RUN mkdir /usr/src/app
ADD requirements.txt /usr/src/app
WORKDIR /usr/src/app

RUN python3 -m pip install -r requirements.txt

ADD . /usr/src/app

CMD "./run.sh"
