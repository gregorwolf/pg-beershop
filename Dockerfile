FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y && apt-get --no-install-recommends -y install nodejs npm && nodejs -v && npm -v
WORKDIR /usr/src/app
COPY gen/srv/package.json .
COPY package-lock.json .
RUN npm ci
COPY gen/srv .
COPY app app/
RUN find app -name '*.cds' | xargs rm -f

EXPOSE 4004
RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node
USER node
CMD [ "npm", "start" ]