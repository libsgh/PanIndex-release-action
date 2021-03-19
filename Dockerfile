ARG CC_CXX_VERSION="6"
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
ENTRYPOINT ["bash","/build-test.sh"]
LABEL maintainer="libsgh <woiyyng@gmail.com>"