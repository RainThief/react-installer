# Stage 1
FROM node:12-alpine as build

COPY . /app

WORKDIR /app

# git useful for git+https packages
RUN apk add --no-cache git=2.24.3-r0

RUN yarn install

RUN chmod 777 node_modules && yarn run build




# Stage 2 - add files to server image
FROM docker.pkg.github.com/rainthief/spa-server/spa-server:0.0.1
COPY --from=build /app/build /var/www/html
