# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.19.0] - 2026-07-14

### Added
- Theme variant gallery and premium code block finish to Jekyll documentation site.
- Automated theme variant preview generation command via `New-ThemeVariantTapes.ps1`.
- `OuterBorderStyle` parameter in `New-PHWriter` for frame customizations.
- `SourceType`, `TextSpacing`, and `OuterBorderStyle` parameters to `Show-PHTheme`.
- `-Compact`, `-Gradient`, `-OuterBorder`, and border gradient switches to `Show-PHTheme`.
- `-Compact` switch (convenience shorthand for `LineSpacing=0`) in `New-PHWriter`.
- Theme support integration for `SectionChar`, `HeaderChar`, and `SyntaxFg` in `Invoke-PHPager`.
- Cross-platform Jekyll documentation runner.
- VHS demo generation stage to GitLab CI pipeline.

### Fixed
- Pester 5 test layout in `test/test-unit-pester.ps1` to run under a single parent `Describe` block.
- Regex parsing error for wide character checking in `Invoke-PHPager` by utilizing .NET surrogate pair and range checks.
- Alignment issues in crystal, nebula, and rust themes by replacing ambiguous-width glyphs.
- Stylesheet loading on the splash layout.
- Examples matching public commands (`Export-PHWriterMetadata` uses `-Path` and router sample uses `-ArgumentList`).
- Missing parameter documentation in the API reference (e.g., pager and palette signatures, and `New-AsciiTokenGradient`).
- Reference links and URLs in `README.md` pointing to Github versus Gitlab.

## [0.4.3-prerelease] - 2025-10-12

### Changed
- Consolidated active development tree.
- Internal structural cleanups and updates to develop branch.

## [0.4.2-prerelease] - 2025-10-09

### Fixed
- Module manifest root module filename loading path.
- Typos in configurations and case-sensitivity issues for `README.md` file.

### Added
- MIT License file.
- SVG logo assets.
- Automated metadata generation script.
- Pester test scripts and gitignore updates.

## [0.3.0] - 2025-07-27

### Added
- Initial project release featuring basic format options, custom color themes, AST parsing, and terminal pager.
