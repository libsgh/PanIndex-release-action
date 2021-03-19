FROM crazymax/xgo:latest

RUN apt-get update
RUN apt-get install -y \
  curl \
  wget \
  git \
  build-essential \
  zip \
  jq
COPY *.sh /
ENTRYPOINT ["/build-test.sh"]
LABEL maintainer="libsgh <woiyyng@gmail.com>"