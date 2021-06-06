FROM node:14-buster-slim

RUN apt-get update && apt-get upgrade -y && nodejs -v && npm -v
WORKDIR /usr/src/app
COPY package.json .
COPY package-lock.json .
RUN npm ci
COPY xs-app.json .
COPY webapp webapp/
RUN find app -name '*.cds' | xargs rm -f

EXPOSE 5000
USER node
CMD [ "npm", "start" ]