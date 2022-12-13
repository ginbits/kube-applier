FROM golang:1.7 as builder
WORKDIR $GOPATH/src/github.com/box/kube-applier
COPY . $GOPATH/src/github.com/box/kube-applier
RUN make build

FROM ubuntu
LABEL maintainer="Greg Lyons<glyons@box.com>"
WORKDIR /root/
ADD templates/* /templates/
ADD static/ /static/
RUN apt-get update
RUN apt-get install -y git curl
RUN git config --global --add safe.directory '*'
RUN curl -LO https://dl.k8s.io/release/v1.23.14/bin/linux/amd64/kubectl
RUN chmod +x kubectl
RUN cp kubectl /usr/local/bin/kubectl
COPY --from=builder /go/src/github.com/box/kube-applier/kube-applier /kube-applier
