ARG BASE_IMAGE=ghcr.io/the-running-dev/docs-template@sha256:1ed8c8b001a0175204cbb8568d9cb018d1f6145fe40b8a209f8179c640d2ffa7
FROM ${BASE_IMAGE}

WORKDIR /template
COPY . .

CMD ["sh", "-c", "pnpm run start:docker"]
