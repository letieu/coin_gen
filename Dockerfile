# build stage
FROM node:lts-alpine as builder
WORKDIR /app
RUN npm install -g pnpm
COPY package*.json ./
RUN pnpm i
COPY . .
RUN ls -a
RUN pnpm run build

#  server
FROM nginx:stable-alpine as server

COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html
