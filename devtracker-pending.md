# Developer Tracker — Pending Tasks

This is the canonical tracker for outstanding work. The historical `devtacker-pending.md` remains untouched for reference.

## P0 — Release blockers
- [x] Better VHS showcase sources are available for AST metadata extraction, theme variants, ASCII logo rendering, and router dispatch. Render them with `pwsh vhs/Invoke-VhsBuild.ps1` once the external `vhs` CLI is installed.
  - [x] Add AST metadata extraction tape.
  - [x] Add theme-variant tape.
  - [x] Add ASCII logo tape.
  - [x] Add router tape and expand router documentation.
- [x] Add GitLab Pages deployment compression and group splash-page theme examples. The `pages` job produces GZIP and Brotli assets from the Jekyll build, and the splash page links to base, gradient, extended, and hard-bordered theme families.
- [x] Repair the Pester 5 test layout in `test/test-unit-pester.ps1`. Setup is now scoped beneath a parent `Describe`; all 56 tests execute under Pester 5.8 with strict-mode module loading.
- [x] Make the Jekyll site reproducibly buildable on Linux. Generated Jekyll/Bundler paths are ignored, vendor output is removed from the index, and the documented clean Bundler build completes successfully.

## P1 — Documentation correctness and release metadata

- [x] Establish one release version as the source of truth. `Get-ConventionalCommitVersion` calculated `0.18.0` from tag `0.4.3-prerelease` (`minor`, 126 commits); the manifest, build environment, docs configuration, and theme showcase now use it.
- [x] Correct examples to match the public commands: `Export-PHWriterMetadata` now uses `-Path` and the router sample uses `-ArgumentList`.
- [x] Complete the API reference from command metadata. It includes the omitted parameters, pager/palette signatures, and the exported `New-AsciiTokenGradient` function.
- [x] Replace copied package/install references in `README.md` that point to `commitfusion`, and reconcile GitHub versus GitLab issue/source URLs and the stale `Docsurl` in `phwriter.psd1`.
- [x] Add a lightweight documentation contract test that imports the module and checks every exported command appears in the docs data and API reference, while rejecting stale parameter/package examples.

## P2 — Docs-site polish

- [x] Keep Just the Docs as the only site framework. The splash layout now uses reusable classes defined in custom Sass rather than a second inline-styled visual system.
- [x] Fix the homepage preview markup. It uses a valid responsive `<img>`, an H1, semantic main landmark, and horizontal scrolling only within the terminal example.
- [x] Simplify code-block chrome and provide a keyboard-accessible copy control. Just the Docs native copy control remains enabled, has a visible focus state, and block code uses one border treatment.
- [x] Replace emoji/ambiguous glyphs in the web theme catalogue with a clear decorative-terminal policy. The catalogue no longer renders them as web data; each theme links to an exact terminal preview command instead.
- [ ] Generate per-theme preview assets from the checked-in VHS tapes. The `vhs_build` CI job now installs VHS and renders the checked-in showcase tapes before the Pages build; per-theme assets under `docs/assets/themes-previews/` still need dedicated tapes and disclosures.
- [x] Audit navigation ordering. Each page now has a unique, sequential `nav_order`.
- [x] Host or bundle fonts deliberately and supply system fallbacks. External Google Font imports are removed and the site uses system UI/monospace font stacks.

## P3 — Module hardening

- [x] Add `Set-StrictMode -Version Latest` and a deliberate `$ErrorActionPreference` policy in the root module loader, then test module import under strict mode.
- [x] Make source loading deterministic: private/public `.ps1` paths are ordinal-sorted before the combined script block is created.
- [x] Declare aliases consistently in both function attributes and the manifest. `Get-TerminalPallete` is retained as a documented compatibility alias alongside `terpal`.
- [x] Remove the duplicate root `New-AsciiTokenGradiant.ps1` implementation. The authoritative token-gradient source is `Public/New-AsciiTokenGradient.ps1`, with tokenization in `Private/ConvertTo-AsciiTokens.ps1`.

## Review evidence

- Module import and `Test-ModuleManifest` passed on PowerShell 7.6.3.
- Pester 5.8.0 executes the test suite under the parent `Describe` with strict-mode module loading.
- A clean Jekyll build succeeds on Linux using `BUNDLE_IGNORE_CONFIG=1 BUNDLE_PATH=/tmp/phwriter-bundle bundle exec jekyll build --destination /tmp/phwriter-docs-build` from `docs/`.
