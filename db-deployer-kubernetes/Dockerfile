FROM node:18 AS build-env
WORKDIR /app
COPY gen/pg .

RUN npm install --only=production

FROM gcr.io/distroless/nodejs:18
#FROM gcr.io/distroless/nodejs18-debian11:debug
COPY --from=build-env /app /app
WORKDIR /app
EXPOSE 4004
ENV NODE_ENV=production

CMD [ "echo", "standard command was executed" ]
