# Multi-stage сборка
FROM node:14.16.1-slim as backend-builder
WORKDIR /builder
COPY ./backend/package*.json ./
RUN npm install
COPY ./backend/common ./common

FROM node:14.16.1-slim
WORKDIR /usr/src/app/frontend
COPY ./frontend/package*.json ./
RUN npm install
COPY --from=backend-builder /builder/node_modules /usr/src/app/backend/node_modules
COPY --from=backend-builder /builder/common /usr/src/app/backend/common
COPY ./frontend/ .

RUN chown -R node:node /usr/src/app
USER node

EXPOSE 3002
CMD ["npm", "run", "start"]