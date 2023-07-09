FROM node:18 AS build-env
WORKDIR /app

COPY package.json .
COPY package-lock.json .
RUN npm ci
COPY xs-app.json .
COPY webapp webapp/
RUN find app -name '*.cds' | xargs rm -f

FROM gcr.io/distroless/nodejs:18
COPY --from=build-env /app /app
WORKDIR /app
EXPOSE 5000
ENV NODE_ENV=production
CMD [ "npm", "start" ]
