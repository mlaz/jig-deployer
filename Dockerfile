FROM phusion/baseimage:0.11

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update -y
RUN apt-get upgrade -y 

RUN apt-get install curl -y
RUN apt-get install git -y

RUN apt-get install autoconf libtool-bin pkg-config build-essential -y
RUN apt-get install golang-go gcc-arm-linux-gnueabihf -y

#ToDo: Enable arm repos, so we can compile openocd with jlink support
#RUN apt-get install libusb-dev libusb-1.0-0-dev libhidapi-dev libjaylink-dev libftdi-dev -y

RUN useradd -ms /bin/bash dev
USER dev
ENV HOME /home/dev
ENV USER dev
ENV SHELL /bin/bash
WORKDIR /home/dev
ADD . /home/dev/jig

# Install rust
RUN curl https://sh.rustup.rs -o rustup.sh && sh rustup.sh -y
RUN echo "export PATH=~/.cargo/bin:l$PATH" >> ~/.bashrc
ENV PATH="/home/dev/.cargo/bin:${PATH}"
RUN rustup target install armv7-unknown-linux-gnueabihf

# Setup go
RUN echo "export GOPATH=$HOME/jig/go" >> ~/.bashrc

USER root
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*