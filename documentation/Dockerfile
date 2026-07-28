ARG BASE_IMAGE=ghcr.io/the-running-dev/docs-template:latest
FROM ${BASE_IMAGE}

WORKDIR /template
COPY . .

CMD ["sh", "-c", "pnpm run start:docker"]
