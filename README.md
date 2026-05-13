# nerfify-site

Marketing site for [Nerfify](https://codeberg.org/whirlwin/nerfify),
served by [Codeberg Pages][cbpages] at <https://nerfify.whirlwin.io>.

The Android app lives in a separate private repo. This repo is public
so Codeberg Pages can serve it.

## Files

- `index.html` — landing page
- `PRIVACY.html` — privacy policy (URL referenced in the Play Store listing)
- `styles.css` — shared dark-editorial theme
- `assets/icon.svg` — app icon (mirrored from the app repo)
- `.domains` — Codeberg Pages custom-domain manifest (`nerfify.whirlwin.io`)
- `deploy.sh` — publishes the repo content to the `pages` branch

## Local preview

No build step:

```sh
python3 -m http.server 8080
# then visit http://localhost:8080
```

## Publishing

Codeberg Pages serves the root of the **`pages` branch** of this repo
at `https://whirlwin.codeberg.page/nerfify-site/`, plus any host listed
in `.domains`. `deploy.sh` packages the working tree (minus
source-only files) into one orphan commit on that branch and
force-pushes it:

```sh
./deploy.sh
```

The `pages` branch is a deploy artifact (no history — squashed on every
publish). `main` keeps the source history.

## Custom domain

`.domains` lists `nerfify.whirlwin.io`. For HTTPS to provision, add the
DNS record:

```
nerfify.whirlwin.io.   IN  CNAME   whirlwin.codeberg.page.
```

Codeberg requests a Let's Encrypt certificate automatically once the
CNAME resolves and the host appears in `.domains`. See the
[Codeberg Pages custom-domain docs][cbcustom].

## Updating the privacy page

Mirror `android-app/PRIVACY.md` from the app repo when the policy
changes, bump the "Last updated" date in `PRIVACY.html`, then
`./deploy.sh`.

[cbpages]: https://docs.codeberg.org/codeberg-pages/
[cbcustom]: https://docs.codeberg.org/codeberg-pages/using-custom-domain/
