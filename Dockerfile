FROM techknowlogick/xgo:go-1.16.2

RUN apt-get update
RUN apt-get install -y \
  curl \
  wget \
  git \
  build-essential \
  zip \
  jq
COPY *.sh /
ENTRYPOINT ["bash","/entrypoint.sh"]
LABEL maintainer="libsgh <woiyyng@gmail.com>"