FROM node:16.20 AS build
WORKDIR /website
RUN npm install --global pnpm@7.29.1
COPY . ./
RUN pnpm install --frozen-lockfile
RUN pnpm run build

FROM nginx:1.23 AS runtime
WORKDIR /website
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY --from=build /website/dist/ ./
