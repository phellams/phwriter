# Developer Tracker — Pending Tasks

This is the canonical tracker for outstanding work. The historical `devtacker-pending.md` remains untouched for reference.

## P0 — Release blockers
### **Uncategorized**
## P1 — Documentation correctness and release metadata
## P2 — Docs-site polish
## P3 — Module hardening
## Review evidence
- Module import and `Test-ModuleManifest` passed on PowerShell 7.6.3.
- Pester 5.8.0 discovered 56 tests but executed none because of root-level `BeforeEach` setup.
- Docs build was attempted from `docs/`; it stopped at the committed/vendor Bundler JSON native extension with `invalid ELF header`.
- [ ] OuterBorderType block and char that take up more vertiacal space add padding of 1 line below to make the MODEName Line have proper spacing
- [ ] Gradient Mode Either Doent work or has not bee set in Show-PHTheme
- [ ] Lets Allow the User to set Highlights this will height ight the Modelname | cmdlet | version
- [ ] Lets allow the user to also set the Case of Titles, 
- [ ] text-spacing does nothing in show-phthtme
- [ ] Make the Jekyll site reproducibly buildable on Linux. `bundle exec jekyll build` from `docs/` fails because `docs/vendor/bundle/.../json/ext/parser.so` has an invalid ELF header. Do not commit platform-specific Bundler output; ignore `docs/vendor/`, then install dependencies for the active platform in CI/local setup.

- [ ] Establish one release version as the source of truth. The manifest reports `0.5.0`, while the docs config, downloads, manual asset URLs, and demo script state `v2.0.0`. Generate or inject the docs version from the release pipeline, and publish only URLs that exist for that version.
- [ ] Correct examples to match the public commands: `Export-PHWriterMetadata` accepts `-Path`, not `-FilePath`; `New-PHRouter` should use its actual argument parameter rather than the undocumented `-Args` sample.
- [ ] Complete the API reference from command metadata. It omits public parameters including `GradientMode`, `OuterBorderStyle`, `Width`, `KeepOutput`, and `Help`; the `Invoke-PHPager` and `Get-TerminalPalette` signatures also need verification against `Get-Command`.
- [ ] Replace copied package/install references in `README.md` that point to `commitfusion`, and reconcile GitHub versus GitLab issue/source URLs and the stale `Docsurl` in `phwriter.psd1`.
- [ ] Add a lightweight documentation contract test that imports the module, compares exported commands/parameters with docs data, and validates local Markdown links and assets.

- [ ] Keep Just the Docs as the only site framework, but move the homepage's inline styles into the custom Sass source. Create reusable tokens/components for terminal demos, code blocks, buttons, and callouts rather than maintaining a second standalone visual system in `_layouts/splash.html`.
- [ ] Fix the homepage preview markup: replace the non-standard `<image>` element with `<img>`, add an H1-equivalent page heading/accessible landmark strategy, and ensure the terminal preview remains usable at narrow widths without clipping content.
- [ ] Simplify code-block chrome to one border treatment and provide a clearly visible, keyboard-accessible copy control. Current nested borders (`pre.highlight` plus inline-code borders) visually compete with the terminal treatment.
- [ ] Replace emoji/ambiguous glyphs in the web theme catalogue with the terminal-safe glyphs actually supported by the module, or describe them as decorative web-only symbols. The current catalogue contradicts the module's safe-glyph policy.
- [ ] Generate per-theme preview assets from the checked-in VHS tapes and add a details disclosure for each theme's command/configuration. Keep generated previews under `docs/assets/themes-previews/` and verify the theme count from the actual theme source.
- [ ] Audit navigation ordering: `downloads.md` and `metadata-extraction.md` both use `nav_order: 2`, while `tui-pager.md` and `api-reference.md` both use `nav_order: 3`.
- [ ] Host or bundle fonts deliberately and supply system fallbacks. The site currently depends on Google Fonts and mixes Inter/JetBrains Mono in the splash layout with only JetBrains Mono in custom Sass.

- [ ] Add `Set-StrictMode -Version Latest` and a deliberate `$ErrorActionPreference` policy in the root module loader, then test module import under strict mode.
- [ ] Make source loading deterministic: sort private/public `.ps1` paths before combining them in `phwriter.psm1`, and add an import test that confirms private-helper dependency order.
- [ ] Declare aliases consistently in both function attributes and the manifest; specifically decide whether the backwards-compatible `Get-TerminalPallete` alias is public and document it if retained.
- [ ] Remove or relocate the duplicate root `New-AsciiTokenGradiant.ps1` implementation so the module has one authoritative `ConvertTo-AsciiTokens`/gradient implementation and the spelling is consistent.
