# Developer Tracker - Pending Tasks

## Pirority 1 - High-Priority Tasks
- [x] **My Goal** - a cross platform helper writer that can be use with all of my modules and tools, and other tools if they want to use powershell for that perpose. i want to dev to have full control to output how they want theme how they want and have the ability to customize the theme to their liking.
- [x] **READ** - extended-tui-knowleadge.md - some elements are to avioided for tear for tui
  - [x] **FIX** - remove all problematic glyphs from the theme and only use safe glyphs
- [x] **FIX** blaze theme error
- [x] **Customize-extend** - allow header to be gradient perhaps have a switch for -gradient and -customgradnet where user can specify.
- [x] for all themes i want to be able to optional put a border around the entire help output and have the border be a gradient, with custom gradient if spcified
- [x] the parm name and description should be on the same line, for descriptions that are too long we can use the pager to scroll through the description unsure of the best way to allow the user to specify action.

Pad-AnsiString: 
Line |
4749 |  … t $spacedName -Width $innerWidth -Align 'Center' -PadChar $middleChar
     |                                                              ~~~~~~~~~~~
     | Cannot process argument transformation on parameter 'PadChar'. Cannot convert value "🔥" to type "System.Char". Error: "String must be exactly one character long."

## Performance & Optimization

- [x] Identify root causes of slow module import (~1.4s overhead)
- [x] Refactor [New-Paragraph.ps1](file:///mnt/g/devspace/projects/powershell/_repos/phwriter/Private/New-Paragraph.ps1) to remove dynamic C# compilation (`Add-Type`), converting to a high-performance pure PowerShell `.NET`-first implementation with `[System.Text.StringBuilder]`
- [x] Redesign [phwriter.psm1](file:///mnt/g/devspace/projects/powershell/_repos/phwriter/phwriter.psm1) root loader to combine all public and private files in memory and execute them as a single compiled script block, avoiding sequential parser/compiler overhead
- [x] Run local build (`localbuild.ps1 -Build -pester`) to verify 100% test coverage and zero regressions
- [x] Conduct final pre-beta codebase, manifest, and performance review

## Future Scope / Ideas
- [ ] Implement build-time source consolidation directly into `psmpacker` to automate single-file packaging for release distributions

## Enhancements & Theme Implementations

- [x] Fix: Theme parameter ValidateSet constraint issues in `New-PHWriter` and `Show-PHTheme` to allow custom themes
- [x] Swap `(req)` label to be at the end of the parameter name (e.g. `Path (Req)`)
- [x] Implement conditional description layout (inline if description fits, new line with indentation if description is long)
- [x] Add subtle color formatting to the pipe `|` character in shorthand parameters (e.g. `-p|Path`)
- [x] Implement 10 new hard-bordered themes using ASCII shapes (including reserving `drift-blue-orange`)
- [x] Syntax highlight words in parameter descriptions surrounded by single quotes (`'word'`) as bold italic with a subtle theme-specific color offset
- [x] Implement syntax highlighting for PowerShell examples using token-based regex parsing
- [x] Extend theme color palette integration to `New-PHRouter` and `Invoke-PHPager`
- [x] Update `PHWriter` module to fully utilize itself by adding a `-Help` switch to all public cmdlets

