FROM python:3.6.5-alpine3.7

MAINTAINER flavioclesio.com <flavioclesio@gmail.com>

COPY bin/install_deps.sh /usr/local/bin

WORKDIR /usr/src/app

RUN apk update && \
  apk add bash gcc postgresql-dev musl-dev && \
  pip install --upgrade pip && \
  chmod +x /usr/local/bin/install_deps.sh

CMD ["python3"]