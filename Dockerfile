FROM node:12-alpine AS builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force
COPY . .
RUN npm run build && rm -rf node_modules

FROM node:12-alpine AS production
WORKDIR /usr/src/app
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

COPY package*.json ./
RUN npm i --production && \
    npm cache clean --force
COPY . .
COPY --from=builder /usr/src/app/dist ./dist
EXPOSE 4000
CMD [ "npm", "run", "start:prod" ]