# Mojidraw website

This is the Mojidraw website.

## Available commands

### Dependency management

- Install dependencies

`pnpm install`

- List outdated dependencies

`pnpm outdated`

- Upgrade dependencies

`pnpm upgrade`

### Build

- Build release artifacts

`pnpm build`

### Quality assurance

- Run static code analysis

`pnpm run lint`

### Development

- Run development server

`pnpm run dev`

- Format code

`pnpm run format`

- Build and run Docker image

```
docker build . -t website
docker run -p 8080:80 website
```
