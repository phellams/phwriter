# FetchTVDB Demo Module

This is a demonstration PowerShell module designed to showcase the advanced features of **PHWriter**, including ASCII logo headers, tag-padded metadata, customizable theme layouts, multi-line subcommand wrapping, and the interactive terminal user interface (TUI) pager.

---

## Architecture

This demo module adheres strictly to the **phellams-aa** module architecture guidelines:
* ◈ **Root Module Loader** (`invoke-fetchtvdb.psm1`) dot-sources public cmdlets from `/Public` and private helper functions from `/Private`, strictly controlling member exports.
* ◈ **File-Per-Cmdlet** (`Public/Invoke-FetchTvdb.ps1`) houses the primary CLI router cmdlet.
* ◈ **Encapsulated Helpers** reside in `/Private` to isolate internal logic.
* ◈ **.NET First Performance** is applied using C# classes (`[System.Text.StringBuilder]`, etc.) for high-speed routing and data manipulation.

---

## How to Run the Demo

1. Open a PowerShell terminal in the repository root.
2. Import the demo module:
   ```powershell
   Import-Module ./demo/fetchtvdb/invoke-fetchtvdb.psm1 -Force
   ```
3. Run the main router cmdlet with `-Help` to open the interactive TUI Help Pager:
   ```powershell
   Invoke-FetchTvdb -Help
   ```
4. Test subcommand dispatching and Levenshtein fuzzy matching:
   ```powershell
   Invoke-FetchTvdb -Mode searhc  # Typo in mode will suggest the closest match 'search'
   ```
5. Run help for a specific subcommand:
   ```powershell
   Invoke-FetchTvdb help search
   # or
   Invoke-FetchTvdb -Mode search -Help
   ```
