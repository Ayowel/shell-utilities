FROM ubuntu

ARG SHELLSPEC_VERSION=0.28.1
ARG SHELLSPEC_SOURCE=https://github.com/shellspec/shellspec/releases/download/${SHELLSPEC_VERSION}/shellspec-dist.tar.gz

RUN apt-get update && \
      apt-get install -y shellcheck kcov make curl && \
      curl -Lo shellcheck.tar.gz "$SHELLSPEC_SOURCE" && \
      tar -xzf shellcheck.tar.gz -C /usr/bin --strip-components 1 && \
      rm -f shellcheck.tar.gz
