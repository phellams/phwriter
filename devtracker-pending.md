# Developer Tracker — Pending Tasks

This is the canonical tracker for outstanding work. The historical `devtacker-pending.md` remains untouched for reference.

## EPIC — PHWriter Core Hardening & Pipeline Integration

> Epic: Make `New-PHWriter` pipeline-compatible with `Export-PHWriterMetadata`, add global theme config,
> param-level help search, and fix `Show-PHTheme` static preview bug.

### Tasks

- [ ] 🌀 **[EPIC/COMPAT]** `Export-PHWriterMetadata` → `New-PHWriter` pipeline: property names from the
      metadata object (`name`, `commandinfo`, `paramtable`, `sourcetype`, `examples`, `version`) do not
      map 1-to-1 with `New-PHWriter` parameters (`Name`, `CommandInfo`, `ParamTable`, `SourceType`,
      `Examples`, `Version`). Add a `ValueFromPipeline` parameter set to `New-PHWriter` that accepts a
      metadata hashtable/PSObject directly and maps all fields internally.
- [ ] 🌀 **[EPIC/GLOBALCFG]** `$global:__phwriter` config variable: Allow users to set a module-wide
      default theme and rendering preferences via `$global:__phwriter = @{ theme_config = @{ theme = 'aurora'; gradient = $true } }`. 
      `New-PHWriter` resolves theme in precedence order: explicit `-Theme` param > global config > built-in default `'phwriter'`.
      Allow partial override (e.g. user sets global theme but passes `-Gradient` explicitly — both apply).
- [ ] 🌀 **[EPIC/HELPSEARCH]** Param-level help search: add `-HelpParam <string>` to `New-PHWriter` and
      `Show-PHTheme`. When specified, filter the rendered output to show only the matching parameter row
      (or scroll to it in pager mode). Support partial/fuzzy match on the param name.
- [ ] 🟡 **[BUG]** `Show-PHTheme`: first preview is static — the `begin {}` block captures `$resolvedLineSpacing`
      once and mock objects are never refreshed when called via pipeline or router. Move all per-call
      state into the `process {}` block. Also the `ThemePreview:` label does not update with each new
      `-Name` call in some router invocations.
- [ ] 🟡 **[FEATURE]** `Show-PHTheme`: add alias `shldc`; export via `phwriter.psm1`.
- [ ] 🟡 **[FEATURE]** `New-PHRouter`: allow `Show-PHTheme` and other public cmdlets to be addressable
      as subcommand routes in the default router dispatch table.
- [ ] 🟢 **[QOL]** `New-PHWriter` pipeline param set: accept `-InputObject` (pipeline) of type
      `[hashtable]` or `[PSCustomObject]` mapping metadata fields, with `-Theme` as an additional
      pipeline-side parameter to set the theme at call site.
- [ ] 🟢 **[QOL]** Global config merging: when `$global:__phwriter.theme_config` is a hashtable,
      deep-merge it with the resolved theme object so users can override individual theme keys
      (e.g. `AccentColor`) without replacing the whole theme.
- [ ] 🟢 **[QOL]** `-HelpParam` route search: support `Show-PHTheme -HelpParam <name>` to display only
      a param-filtered view, bypassing the full preview loop.

## P0 — Release blockers

- [ ] OuterBorderType block and char that take up more vertiacal space add padding of 1 line below to make the MODEName Line have proper spacing
- [ ] Gradient Mode Either Doent work or has not bee set in Show-PHTheme
- [ ] Lets Allow the User to set Highlights this will height ight the Modelname | cmdlet | version
- [ ] Lets allow the user to also set the Case of Titles,
- [ ] text-spacing does nothing in show-phthtme
- [x] Repair the Pester 5 test layout in `test/test-unit-pester.ps1`. Setup is now scoped beneath a parent `Describe`; all 56 tests execute under Pester 5.8 with strict-mode module loading.
- [x] Make the Jekyll site reproducibly buildable on Linux. Generated Jekyll/Bundler paths are ignored, vendor output is removed from the index, and the documented clean Bundler build completes successfully.
- [x] Better VHS showcase sources are available for AST metadata extraction, theme variants, ASCII logo rendering, and router dispatch. Render them with `pwsh vhs/Invoke-VhsBuild.ps1` once the external `vhs` CLI is installed.
  - [x] Add AST metadata extraction tape.
  - [x] Add theme-variant tape.
  - [x] Add ASCII logo tape.
  - [x] Add router tape and expand router documentation.
- [x] Add GitLab Pages deployment compression and group splash-page theme examples. The `pages` job produces GZIP and Brotli assets from the Jekyll build, and the splash page links to base, gradient, extended, and hard-bordered theme families.

## P1 — Documentation correctness and release metadata

- [x] Establish one release version as the source of truth. `Get-ConventionalCommitVersion` calculated `0.19.0` from tag `0.4.3-prerelease` (`minor`, 134 commits); the manifest, build environment, docs configuration, and theme showcase now use it.
- [x] Correct examples to match the public commands: `Export-PHWriterMetadata` now uses `-Path` and the router sample uses `-ArgumentList`.
- [x] Complete the API reference from command metadata. It includes the omitted parameters, pager/palette signatures, and the exported `New-AsciiTokenGradient` function.
- [x] Replace copied package/install references in `README.md` that point to `commitfusion`, and reconcile GitHub versus GitLab issue/source URLs and the stale `Docsurl` in `phwriter.psd1`.
- [x] Add a lightweight documentation contract test that imports the module and checks every exported command appears in the docs data and API reference, while rejecting stale parameter/package examples.

## P2 — Docs-site polish

- [x] Keep Just the Docs as the only site framework. The splash layout now uses reusable classes defined in custom Sass rather than a second inline-styled visual system.
- [x] Fix the homepage preview markup. It uses a valid responsive `<img>`, an H1, semantic main landmark, and horizontal scrolling only within the terminal example.
- [x] Simplify code-block chrome and provide a keyboard-accessible copy control. Just the Docs native copy control remains enabled, has a visible focus state, and block code uses one border treatment.
- [x] Replace emoji/ambiguous glyphs in the web theme catalogue with a clear decorative-terminal policy. The catalogue no longer renders them as web data; each theme links to an exact terminal preview command instead.
- [x] Generate per-theme variant preview assets from checked-in VHS sources. `New-ThemeVariantTapes.ps1` derives 200 tapes (Base, Rounded, Double, and Gradient for each public theme) from the `Show-PHTheme` ValidateSet, `vhs_build` renders GIFs under `docs/assets/themes-previews/`, and the themes page exposes every variant and generation command through one reusable include.
- [x] Audit navigation ordering. Each page now has a unique, sequential `nav_order`.
- [x] Load JetBrains Mono deliberately for documentation code and retain system fallbacks. The splash layout preconnects to the font host and loads only the required weights.

## P3 — Module hardening

- [x] Add `Set-StrictMode -Version Latest` and a deliberate `$ErrorActionPreference` policy in the root module loader, then test module import under strict mode.
- [x] Make source loading deterministic: private/public `.ps1` paths are ordinal-sorted before the combined script block is created.
- [x] Declare aliases consistently in both function attributes and the manifest. `Get-TerminalPallete` is retained as a documented compatibility alias alongside `terpal`.
- [x] Remove the duplicate root `New-AsciiTokenGradiant.ps1` implementation. The authoritative token-gradient source is `Public/New-AsciiTokenGradient.ps1`, with tokenization in `Private/ConvertTo-AsciiTokens.ps1`.
- [x] Smart param alias: automatically generate short aliases for cmdlet parameters without conflicting with common parameters or other parameter names.

## Review evidence

- Module import and `Test-ModuleManifest` passed on PowerShell 7.6.3.
- Pester 5.8.0 executes the test suite under the parent `Describe` with strict-mode module loading.
- A clean Jekyll build succeeds on Linux using `BUNDLE_IGNORE_CONFIG=1 BUNDLE_PATH=/tmp/phwriter-bundle bundle exec jekyll build --destination /tmp/phwriter-docs-build` from `docs/`.
