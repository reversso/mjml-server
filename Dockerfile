ARG NODE_VERSION=24.22.1-alpine
FROM node:${NODE_VERSION}

WORKDIR /app
COPY ./package.json ./package-lock.json /app/
RUN node -e 'if (process.versions.node !== "24.22.1") process.exit(1)' \
    && npm ci --no-audit --no-fund
EXPOSE 15500
COPY . /app/
ENTRYPOINT ["node", "./index.js"]
