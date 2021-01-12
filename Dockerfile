FROM karalabe/xgo-1.13.4
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  curl \
  wget \
  git \
  build-essential \
  zip \
  jq\
COPY *.sh /
ENTRYPOINT ["/entrypoint.sh"]
LABEL maintainer="libsgh <woiyyng@gmail.com>"