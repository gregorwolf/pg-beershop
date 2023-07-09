FROM node:18 AS build-env
WORKDIR /app
COPY gen/srv/package.json .
COPY package-lock.json .

RUN npm ci --omit=dev

COPY gen/srv .
COPY app app/
RUN find app -name '*.cds' | xargs rm -f

FROM gcr.io/distroless/nodejs:18
COPY --from=build-env /app /app
WORKDIR /app
EXPOSE 4004
ENV NODE_ENV=production
CMD ["node_modules/@sap/cds/bin/cds-serve.js"]
