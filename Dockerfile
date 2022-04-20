FROM node:14 AS build-env
WORKDIR /app
COPY gen/srv/package.json .
COPY package-lock.json .

RUN npm ci --only=production

COPY gen/srv .
COPY app app/
RUN find app -name '*.cds' | xargs rm -f

FROM gcr.io/distroless/nodejs:14
COPY --from=build-env /app /app
WORKDIR /app
EXPOSE 4004
CMD ["node_modules/@sap/cds/bin/cds.js", "run"]