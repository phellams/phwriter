---
layout: default
title: TUI Pager
nav_order: 3
description: "Interactive terminal pager for viewing long cmdlet help pages."
---

# TUI Pager

`Invoke-PHPager` (aliased as `phpager`) provides an interactive, terminal-native paging view for reading long help pages without cluttered text overflow.

## Keyboard Controls

| Key | Action |
|---|---|
| **Up / Down / PgUp / PgDn** | Scroll lines or pages up/down |
| **Home / End** | Go to the top / bottom of the content |
| **q / Escape** | Exit pager |

## Alternate Screen Buffer

By default, the pager runs inside the alternate screen buffer, meaning when you exit, the original terminal contents are restored cleanly.

## Non-Interactive Host Bypass

To prevent blocking in non-interactive environments (like CI/CD pipelines), set the following environment variable:

```powershell
$env:PHWRITER_TEST_MODE = 'true'
```
This forces the pager to print all contents directly to standard output and exit immediately.
