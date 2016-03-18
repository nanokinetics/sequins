FROM golang:1.6

RUN apt-get update
RUN apt-get install -y build-essential autoconf libtool pkg-config

ADD . /go/src/github.com/stripe/sequins
RUN mkdir -p /build/
WORKDIR /go/src/github.com/stripe/sequins
CMD /go/src/github.com/stripe/sequins/jenkins_build.sh
