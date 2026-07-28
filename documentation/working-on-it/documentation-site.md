---
sidebar_label: Documentation Site
---

# The Documentation Site

The repository's `documentation/` directory is both the authored documentation root and the
Docusaurus site project. It is deployed to GitHub Pages by the same container-backed workflow
used by the Game Engine.

## Authored and Generated Files

All Markdown below `documentation/` is authored directly except `documentation/index.md`.
That file is generated from the repository `README.md`; edit the README, regenerate the page,
and commit both files. The documentation gate checks that they match.

The category directories are source organization, not an automatic information architecture.
Add each new page to `documentation/sidebar.ts`, where the reading order and public
navigation are declared explicitly.

## Local Checks

Run the repository-wide Markdown gate:

```powershell
./build/Test-Documentation.ps1
```

Build the documentation image with Docker Desktop running:

```powershell
docker build --tag sun-trap-docs ./documentation
```

The continuous-integration workflow runs the Markdown gate and a production Docusaurus build
for pull requests. The Pages deployment runs the same Markdown gate before it builds or
publishes. A push to `main` also deploys the built site to GitHub Pages.

## Pinned Documentation Image

The documentation template is pinned to the same immutable image manifest digest in
`documentation/Dockerfile`, Docs CI, and Docs Deploy. To update it, inspect the intended
template tag with `docker manifest inspect --verbose`, review the image change, and update all
three references in one pull request. Never substitute a mutable tag such as `latest`.

## Link Rules

Use relative links only for files that ship inside `documentation/`. Link to root-level files
with the appropriate relative traversal, such as `../../README.md`; the Markdown gate checks
that those paths and heading anchors exist. Use site-absolute links for published routes only
when the route is known; the Docusaurus build validates them.

The Game Engine is external to this site's build context. Link readers to its published
documentation instead of writing a relative path into another repository.
