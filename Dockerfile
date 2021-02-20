FROM crazymax/xgo:1.16.x

RUN apt-get update
RUN apt-get install -y \
  curl \
  wget \
  git \
  build-essential \
  zip \
  jq
COPY *.sh /
ENTRYPOINT ["/entrypoint.sh"]
LABEL maintainer="libsgh <woiyyng@gmail.com>"