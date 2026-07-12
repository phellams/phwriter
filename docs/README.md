# Documentation site

The site uses Jekyll and Just the Docs. Generated output and Bundler installations are local-only and are not committed.

## Build

From the repository root, use the cross-platform helper:

```powershell
pwsh ./Build-Docs.ps1 -Build
pwsh ./Build-Docs.ps1 -Serve
```

The helper resolves its paths from its own location, keeps Bundler files in the system temporary directory, writes the generated site to `docs/public/`, and enables live reload for `-Serve`.

The equivalent manual build commands, run from the `docs` directory, are:

```bash
BUNDLE_IGNORE_CONFIG=1 BUNDLE_PATH=/tmp/phwriter-bundle bundle install
BUNDLE_IGNORE_CONFIG=1 BUNDLE_PATH=/tmp/phwriter-bundle bundle exec jekyll build --destination /tmp/phwriter-docs-build
```

## Deployment

The `vhs_build` job renders every tape in `vhs/` before the `pages` job builds the site into `public/`. The Pages artifact includes the generated GIFs plus GZIP and Brotli variants of HTML, CSS, JavaScript, XML, text, and SVG assets. GitLab Pages selects a compressed variant when the browser supports it.

For regular local development, choose any local Bundler path outside the repository and run `bundle exec jekyll serve` with the same environment variables.
