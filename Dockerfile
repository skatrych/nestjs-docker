FROM node:14.17.3-alpine3.14 AS builder

WORKDIR /usr/src/app

COPY package.json ./
COPY package-lock.json ./
RUN npm install
COPY . .
RUN npm run build
RUN ls ./dist

FROM node:14.17.3-alpine3.14 AS production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package.json ./

RUN npm install --only=production

# COPY .env ./
COPY --from=builder /usr/src/app/dist ./dist

# Fixing permission denied error
# RUN chmod o+r .env

EXPOSE 3001
CMD ["node", "dist/main"]
