FROM ubuntu:14.04

RUN apt update && apt install -y \
        curl

RUN curl -L https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.10.0-1_amd64.deb -o chefdk.deb && \
        dpkg -i chefdk.deb && \
        rm chefdk.deb && \
        rm -rf /var/lib/apt/lists/*

VOLUME ["/repo"]
WORKDIR /repo

CMD ["/bin/bash"]

