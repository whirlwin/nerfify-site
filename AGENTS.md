# AGENTS.md — nerfify-site

Static marketing site for the Nerfify Android app. Plain HTML/CSS, no build step.
Served at https://nerfify.com (Cloudflare Pages, project `nerfify`) and mirrored on Codeberg Pages.

## High SEO quality is a hard requirement

Every page change MUST preserve — and every new page MUST include — the following:

- **Canonical URL** (`rel=canonical`) pointing at `https://nerfify.com/...`, using the
  **extensionless** form (`/PRIVACY`, `/no/personvern`) — Cloudflare Pages 308-redirects
  `.html` URLs, and canonicals must never point at a redirect.
- **hreflang alternates** on every page: `en`, `nb`, and `x-default` (→ the English page),
  all as absolute `https://nerfify.com/...` URLs. English and Norwegian pages must
  reference each other symmetrically.
- **Unique, descriptive `<title>` and `meta description`** per page and per language.
- **Open Graph tags**: `og:title`, `og:description`, `og:type`, `og:url`, `og:site_name`,
  `og:locale` (`en_US` / `nb_NO`) + `og:locale:alternate`.
- **JSON-LD structured data** (`MobileApplication`) on both homepages, with `inLanguage`
  matching the page language.
- **`sitemap.xml`** updated for any added/removed/renamed page, including the
  `xhtml:link` hreflang alternates. `robots.txt` must keep pointing at it.
- **Language parity**: content changes to an English page must be mirrored in the
  Norwegian page under `/no/` (Bokmål) in the same change, and vice versa.
  The English privacy policy is the legally authoritative version.
- **Crawlable language switcher**: plain `<a>` links (`.lang` in the header) — no
  JS-based locale detection or redirects.
- Semantic HTML (one `h1`, sectioned `h2`s, `lang` attribute on `<html>`) and
  fast, dependency-light pages — no SPA frameworks, no render-blocking scripts.

Before calling a change done, verify: canonicals resolve with HTTP 200 (no redirect),
hreflang pairs are symmetric, and the sitemap lists exactly the live pages.

## Deploying

- `deploy.sh` publishes to Codeberg Pages (`pages` branch).
- Cloudflare Pages (production, nerfify.com): upload the same tree to the `nerfify`
  project (account `2cb6b3693d8384633f6ad68f3b9d0e0a`), e.g. with
  `npx wrangler pages deploy . --project-name=nerfify` (excluding `deploy.sh`,
  `README.md`, `AGENTS.md`, `CLAUDE.md`, `.domains`, `.gitignore`).
