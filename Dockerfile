FROM karalabe/xgo-1.13.4
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