---
sidebar_label: Documentation Site
---

# The Documentation Site

The repository uses the documentation template's canonical consumer layout. `docs/` is the
installer-managed Docusaurus project and `docs/docs/` contains authored Markdown. The site is
deployed to GitHub Pages by the same container-backed workflow used by the Game Engine.

## Authored and Generated Files

`docs/src/pages/index.md` is generated from the repository `README.md`; edit the README,
regenerate the page, and commit it. The documentation gate checks that it matches. This page
is the public site root. `docs/docs/index.md` is an independently authored landing page for
the `/docs/` section.

The category directories are source organization, not an automatic information architecture.
Add each new page to `docs/sidebar.ts`, where the reading order and public
navigation are declared explicitly.

## Local Checks

Run the repository-wide Markdown gate:

```powershell
./build/Test-Documentation.ps1
```

Preview the installer-managed documentation site with Docker Desktop running:

```powershell
./docs.ps1
```

The continuous-integration workflow runs the Markdown gate and a production Docusaurus build
for pull requests. The Pages deployment runs the same Markdown gate before it builds or
publishes. A push to `main` also deploys the built site to GitHub Pages.

## Pinned Documentation Image

The documentation template is pinned to the same immutable image manifest digest in
`docs/Dockerfile`, `docs.ps1`, Docs CI, and Docs Deploy. To update it, inspect the intended
template tag with `docker manifest inspect --verbose`, review the image change, and update all
four references in one pull request. Never substitute a mutable tag such as `latest`.

## Link Rules

Use relative links only for files that ship inside `docs/docs/`. Link to root-level files
with the appropriate relative traversal, such as `../../../README.md`; the Markdown gate checks
that those paths and heading anchors exist. Use site-absolute links for published routes only
when the route is known; the Docusaurus build validates them.

The Game Engine is external to this site's build context. Link readers to its published
documentation instead of writing a relative path into another repository.
