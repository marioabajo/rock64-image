FROM debian:bullseye

### Config variables:
# do a "git clone" eveytime the container run
ENV UPDATE_CONFIG=0

# Set buildroot version
ENV VERS=2023.02

# Set build command/s
ENV RUNCMD="make"

# Set repository to clone
#ENV REPO="https://github.com/marioabajo/rock64-image"

RUN apt-get update;\
    apt-get install -y build-essential libncurses-dev python wget cpio unzip rsync bc git sudo vim gawk python3-pyelftools unzip; \
    apt-get clean; \
    adduser --disabled-password --gecos "" builder; \
    adduser builder sudo

USER builder
WORKDIR /home/builder

COPY prepare.sh prepare.sh

ENTRYPOINT ["./prepare.sh"]
