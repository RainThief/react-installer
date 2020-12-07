# Stage 1
FROM node:12-alpine as build
COPY . /app
WORKDIR /app
RUN yarn install && yarn run build

# Stage 2 - add files to server image
FROM docker.pkg.github.com/rainthief/spa-server/dds-spa-server:0.0.1
COPY --from=build /app/build /var/www/html
