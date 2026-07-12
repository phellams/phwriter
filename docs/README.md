# Documentation site

The site uses Jekyll and Just the Docs. Generated output and Bundler installations are local-only and are not committed.

## Build

Run from the `docs` directory:

```bash
BUNDLE_IGNORE_CONFIG=1 BUNDLE_PATH=/tmp/phwriter-bundle bundle install
BUNDLE_IGNORE_CONFIG=1 BUNDLE_PATH=/tmp/phwriter-bundle bundle exec jekyll build --destination /tmp/phwriter-docs-build
```

## Deployment

The `pages` job in the root GitLab CI configuration builds the site into `public/` and includes GZIP and Brotli variants of HTML, CSS, JavaScript, XML, text, and SVG assets. GitLab Pages selects a compressed variant when the browser supports it.

For regular local development, choose any local Bundler path outside the repository and run `bundle exec jekyll serve` with the same environment variables.
