FROM devxci/mbtci-java11-node14

WORKDIR /home/mta
USER root
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    jq 

USER mta
COPY gen/db/package.json .
COPY package-lock.json .
RUN npm ci
COPY gen/db .

CMD [ "npm", "start" ]