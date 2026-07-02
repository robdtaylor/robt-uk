# CLAUDE.md

Guidance for AI assistants working in this repository.

## What this is

`robt.uk` — Rob Taylor's personal website and newsletter archive. It's a
**Hugo static site** using the **PaperMod** theme, deployed to **Cloudflare
Pages**. Content is writing about AI and technology, plus archives of two
newsletters. There is no application backend beyond a single Cloudflare Pages
Function that handles newsletter subscriptions.

## Tech stack

- **Hugo** — static site generator (config in `hugo.toml`, TOML format)
- **PaperMod** — theme, pulled in as a git submodule at `themes/PaperMod`
  (see `.gitmodules`). Note: the submodule may not be checked out in a fresh
  clone — run `git submodule update --init --recursive` before building.
- **Cloudflare Pages** — hosting + CI. Pushes to `main` deploy automatically.
- **Cloudflare Pages Functions** — `functions/api/subscribe.js`, a serverless
  endpoint at `/api/subscribe`.
- **Resend** — email/audience provider the subscribe function talks to.

## Repository layout

```
hugo.toml                     Site config: menus, params, social icons, outputs
archetypes/default.md         Front-matter template for `hugo new`
content/
  about.md                    About page
  search.md                   Search page (layout: search)
  newsletter.md               Subscribe page — custom HTML/CSS/JS form (see below)
  posts/                      Long-form blog posts
  the-agent-stack/            "The Agent Stack" newsletter editions (_index.md + posts)
  newsletters/                "AI Daily Briefing" archive (_index.md + ~160 dated posts)
functions/
  api/subscribe.js            Cloudflare Pages Function: POST /api/subscribe
static/
  images/                     Site images (svg/png), incl. images/posts/
scripts/
  publish-editions.sh         Local automation to publish Agent Stack editions
  .publish*.log               Log output from the publish script (committed)
themes/PaperMod/              Theme (git submodule)
```

Build output (`public/`, `resources/_gen/`) and `.hugo_build.lock` are
gitignored — never commit them.

## Content model

Three content sections, each with distinct conventions:

### `content/posts/` — blog posts
Long-form articles. Front matter (YAML):
```yaml
---
title: "..."
date: 2026-01-11
draft: false
description: "..."
tags: ["Claude Code", "AI Tools"]
cover:                        # optional
  image: "/images/foo.png"
  alt: "..."
---
```
Filenames are typically `YYYY-MM-DD-slug.md` (a couple of older ones are just
`slug.md`).

### `content/the-agent-stack/` — The Agent Stack newsletter
Three editions/week: Monday Build, Wednesday Stack, Friday Signal. Each post
tags `"The Agent Stack"` plus a category (`Builds`/`Tools`/`Industry`) and
carries a reference line `*The Agent Stack #NNN — Edition Type*` near the top.
This reference is what the publish script uses for dedup, so keep the format
intact.

### `content/newsletters/` — AI Daily Briefing archive
Auto-generated daily digest posts named `YYYY-MM-DD-ai-daily-briefing.md`.
Tags include `["AI", "Machine Learning", "Newsletter", "Daily Briefing"]`.
These are numerous (~160+) and mostly machine-produced — treat them as an
archive, not hand-maintained prose.

## Key conventions

- **Front matter**: existing content uses **YAML** (`---` fences). The
  `archetypes/default.md` template uses **TOML** (`+++` fences) — Hugo accepts
  both, but match the surrounding files (YAML) when adding content by hand.
- **Drafts**: `buildDrafts = false` in `hugo.toml`. Set `draft: false` to
  publish. `hugo server -D` renders drafts locally.
- **Future dates**: `buildFuture = false` — a post dated in the future won't
  build. Use today's date or earlier.
- **Unsafe HTML is enabled** (`markup.goldmark.renderer.unsafe = true`), so
  content files can embed raw HTML/CSS/JS. The subscribe page relies on this.
- **Menus** are defined in `hugo.toml` under `[[menu.main]]` with `weight`
  ordering. Add nav links there.
- **Output formats**: the home page emits HTML, RSS, and JSON (the JSON feed
  powers PaperMod search).

## Common tasks

### Local development
```bash
hugo server -D          # dev server with drafts at http://localhost:1313
```

### Create a new post
```bash
hugo new posts/my-new-post.md
```
Then edit front matter and set `draft: false` when ready. (Note the archetype
emits TOML front matter; convert to YAML to match existing posts if you prefer
consistency.)

### Build
```bash
hugo                    # outputs to public/
```

### Publishing Agent Stack editions (`scripts/publish-editions.sh`)
This is a **local macOS automation script** (paths under `~/Projects/...`,
Homebrew PATH, launchd-oriented). It reads raw editions from a sibling
`the-agent-stack` project, converts them to Hugo posts in
`content/the-agent-stack/`, builds, and deploys via `wrangler pages deploy`.
It is **not** meant to run in CI or a fresh clone — don't invoke it here. Use
`--dry-run` to preview. When editing it, preserve the `#NNN` dedup logic and
the edition-type → tag mapping.

## The subscribe flow

`content/newsletter.md` is a self-contained subscribe page: inline CSS styles
the newsletter cards, and inline JS POSTs `{ email, newsletters }` to
`/api/subscribe`. The two newsletter values are `agent-stack` and
`daily-briefing`.

`functions/api/subscribe.js` (Cloudflare Pages Function):
- Validates email, filters `newsletters` against the allowed set.
- Maps each newsletter to a Resend audience via env vars
  (`RESEND_AUDIENCE_ID`, `RESEND_AUDIENCE_DAILY_ID`) and subscribes in parallel
  using `RESEND_API_KEY`.
- Handles CORS (`onRequestOptions`) and legacy single-newsletter requests.
- **Secrets** (`RESEND_API_KEY`, audience IDs) are Cloudflare Pages env vars —
  never hardcode or commit them.

If you add a newsletter: update `AUDIENCE_MAP` in `subscribe.js`, add the card
in `newsletter.md`, and configure the audience env var in Cloudflare.

## Deployment

- Pushing to `main` triggers an automatic Cloudflare Pages deploy — no CI
  workflow files in the repo; the build/deploy is configured in the Cloudflare
  Pages dashboard.
- The Cloudflare Pages project name is `robt-uk`.
- There is no test suite, linter, or formatter configured. "Verifying" a
  change means building locally (`hugo`) and/or previewing (`hugo server`).

## Notes for making changes

- Prefer editing content in the right section; keep front matter shape
  consistent with neighboring files.
- Don't commit build artifacts (`public/`, `resources/_gen/`).
- Theme changes go through `themes/PaperMod` (submodule) or, better, via
  `layouts/` overrides at the repo root (none exist yet — create `layouts/` to
  override theme templates rather than editing the submodule).
- Keep the Agent Stack `#NNN — Type` reference line and daily-briefing
  filename pattern intact so downstream automation keeps working.
</content>
</invoke>
