FROM node:16.2.0 AS build
WORKDIR /website

COPY . ./
RUN yarn build

FROM nginx:1.20.0 AS runtime
WORKDIR /website
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY --from=build /website/dist/* ./
