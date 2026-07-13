# Contributing to PHWriter

This document outlines the guidelines and development standards for contributing to the PHWriter project.

## Development Principles

All contributions must adhere to the following principles:

1. **No-Nonsense Code**: Write concise, highly performant code. Avoid unnecessary wrappers or complex scoping rules.
2. **Performance First**: Utilize native .NET classes (e.g., `[System.IO.File]`, `[System.Text.StringBuilder]`) instead of standard PowerShell cmdlets where performance gains are achievable. Ensure all .NET implementations are cross-platform compatible.
3. **Strict Mode**: All code must execute under `Set-StrictMode -Version Latest` with `$ErrorActionPreference = 'Stop'`.

## Architecture Standards

PHWriter follows a structured directory layout:

- **Root Module Loader (`phwriter.psm1`)**: Dot-sources all required `.ps1` files and controls public cmdlet exposure using `Export-ModuleMember`.
- **Public Cmdlets (`Public/`)**: Each public cmdlet must reside in its own `.ps1` file named exactly after the cmdlet (e.g., `New-PHWriter.ps1`).
- **Private Helper Functions (`Private/`)**: Helper functions required by cmdlets reside in the `Private/` directory or encapsulated within the public cmdlet's file.
- **TUI & CLI Design**: Use native ASCII/ANSI escape codes. Calculate string lengths and apply layout padding before encoding string formats with escape sequences to prevent screen tearing.

## Commit Message Guidelines

This repository strictly enforces the Conventional Commits specification. Commit messages must be structured as follows:

```
<type>(<scope>): <description>

[optional body]
```

### Types
- **feat**: A new feature (corresponds to a **Minor** release).
- **fix**: A bug fix (corresponds to a **Patch** release).
- **perf**: A code change that improves performance (corresponds to a **Patch** release).
- **docs**: Documentation updates.
- **test**: Adding or correcting tests.
- **chore**: Build processes, dependency updates, or auxiliary tool changes.

### Breaking Changes
A breaking change must be declared in the commit body prefixed by `BREAKING CHANGE:` to trigger a **Major** version bump.

### Formatting
- Use the imperative mood in the subject line (e.g., "feat(parser): add token detection").
- Do not end the subject line with a period.

## Workflow

1. **Branching**: Develop changes on a feature branch branched from `develop` (`feature/<feature-name>`).
2. **Local Testing**: Run the unit test suite before proposing changes:
   ```powershell
   pwsh -Command "Invoke-Pester ./test/test-unit-pester.ps1"
   ```
3. **Local Building**: Verify the build config and module manifest using the local builder script:
   ```powershell
   ./automator-devops/localbuilder.ps1 -Build -pester
   ```
4. **Merge Requests**: Submit a merge request targeting the `develop` branch. Ensure that all GitLab CI pipeline checks pass.
