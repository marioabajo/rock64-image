FROM debian:buster

### Config variables:
# do a "git clone" eveytime the container run
ENV UPDATE_CONFIG=1

# Set buildroot version
ENV VERS=2021.02.3

# Set build command/s
ENV RUNCMD="make"

RUN apt-get update;\
    apt-get install -y build-essential libncurses-dev python wget cpio unzip rsync bc git sudo vim gawk python-pyelftools unzip; \
    apt-get clean; \
    adduser --disabled-password --gecos "" build; \
    adduser build sudo

USER build
WORKDIR /home/build

COPY build.sh build.sh

ENTRYPOINT ["./build.sh"]
