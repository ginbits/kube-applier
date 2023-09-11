FROM golang:1.7 as builder
WORKDIR $GOPATH/src/github.com/box/kube-applier
COPY . $GOPATH/src/github.com/box/kube-applier
RUN make build

FROM ubuntu

WORKDIR /root/
ADD templates/* /templates/
ADD static/ /static/

RUN apt-get update
RUN apt-get install -y git curl
RUN git config --global --add safe.directory '*'

# Install the latest kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

RUN chmod +x kubectl
RUN cp kubectl /usr/local/bin/kubectl
COPY --from=builder /go/src/github.com/box/kube-applier/kube-applier /kube-applier
