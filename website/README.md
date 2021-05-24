# Mojidraw website

This is the Mojidraw website.

## Available commands

### Dependency management

- Install dependencies

`yarn install`

- List outdated dependencies

`yarn outdated`

- Upgrade dependencies

`yarn upgrade`

### Build

- Build release artifacts

`yarn build`

### Quality assurance

- Run static code analysis

`yarn lint`

### Development

- Run development server

`yarn start`

- Format code

`yarn format`

- Build and run Docker image

```
docker build . -t website
docker run -p 8080:80 website
```
