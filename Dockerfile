FROM node:12-slim

WORKDIR /usr/src/app
COPY gen/srv/package.json .
COPY package-lock.json .
RUN npm install
COPY gen/srv .
COPY app app/
RUN find app -name '*.cds' | xargs rm -f

EXPOSE 4004
USER node
CMD [ "npm", "start" ]