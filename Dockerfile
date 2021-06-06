FROM node:14-buster-slim

RUN apt-get update && apt-get upgrade -y && nodejs -v && npm -v
# causes an error with node:14-buster-slim
# RUN apt-get --no-install-recommends -y install openjdk-11-jre 
WORKDIR /usr/src/app
COPY gen/srv/package.json .
COPY package-lock.json .
RUN npm ci
COPY gen/srv .
COPY app app/
RUN find app -name '*.cds' | xargs rm -f

EXPOSE 4004
# Not needed with node:14-buster-slim
#RUN groupadd --gid 1000 node \
#  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node \
#  && mkdir tmp \
#  && chown node -R tmp
USER node
CMD [ "npm", "start" ]