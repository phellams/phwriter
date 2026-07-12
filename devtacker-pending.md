# Developer Tracker - Pending Tasks

## Priority 1 - High-Priority Tasks
- [ ] there is still a border around the the inner code blocks the need to be one color, and lets have a better copy button and aslo the 3dot window header with langauge 
- [ ] update docs site stylin, using heavy hands for h1 ,inter for paragragh h2 lets choose one that matchs, can we scale the git to fit on the space page, lets have themes, page where we have the theme name, the sytax required to genenration perhaps have that in a details drop down that hidden, we must genrate and addition assets/themes-previews, each theme whichhave a vhs gif where we render the theme name and its possible layout types grafidan borders, 
- [x] make sure we are handle the alt buffer corret, output remains when leave phwriter, we want a smooth and seemless experience, user must clean experierce going from help back to the normal buffer, lets have the alt buffer by default and if the use just wants to print in the normal buffer we should allow that aswellm unsure of to programaticlly do this expecilly with the router function perhaps this is something we programctily see for the dev using the modeul to decide.
- [x] ive authered New-AsciiTokenGradiant.ps1, it is the spiritual sucessor to New-AsciiGradient, employ both to give users with modern termials with RGB support to have the full experice and we keep New-AsciiColor for terminals that dont support, add to phwriter utf8 enable on module import and aslo a check for termalal color support and user 
  - [x] Brialiant idea!! -- the -Mode PerToken we could use this to expand out theme range to infinate if i understand and have tested the logic ok, review this idea and report back.
- [x] I think the module has grown large enough for a jekyll docs site, lets use just the docs theme, but put a dark theme well with outlines and access in orange yellow, to matach module logo, lets all add a default theme called phwriter, and will make it of the same accent.
- [x] after a couple fixes and polish phwriter will go into its second release, make sure we have a summary in readme.md with all features quick getting started details on building etc, and we can leave the more complex documenation for the docs site.
- [x] **sourcetpye** - we can do it two differnt ways, if module/tool/function is a router type function we assume there are subcommands do it would need to read, "cli NAME Function: NAME VERSION" and a module can be both to i gues we split it up standard|router, in doin this we can have each cmdlet have an help and router functions can use command add help and command remove custom Help.
- [x] the tool/modulename function/cmdlet name and Version needs to have padding of +1 left and right giving it that tag like apearance
- [x] the ascii extended chars we use for SYNTAX, DESCRIPTIONm, PARAMETERS, needs to be coloured we what maximum readabilly colors that blend tother that give it that handcraft primum feal, complete, allows the reader to focus on the help content
- [x] **bug/fix** - some themes Description output second line is in a another color, this does happen for all more a few.
- [x] **modern Evolution and nuoucecs** - these are some of the workflows i would use phwriter in invoke-command -help if its a router invoke-Router -mode help which is one of the modes also subcommands Invoke-Router -Mode add -submod Help.
- [x] **Alt Buffer & Paging** — support direct standard buffer dump vs Alt buffer page dump (pager), and default/support automatic pager view like man.
- [x] **Output Width Defaults & Custom** — support output width modes/values: man (80 cols), full (console width), or custom integer size.
- [x] **Console Resize Autoscale** — implement dynamic autoscaling/recalculating of text wrapping and layout when user resizes the terminal console.
- [x] **Minimum Width Safeguard** — add a default minimum width (45 cols) safeguard that displays a notification instead of printing broken/torn layout.
- [x] **High-Performance C# classes** — utilize high-performance C# types like StringBuilder and accurate length-calculations prior to ANSI encoding.
- [x] **alt** buffer is New-PHWriter using the alternate buffer? if its not i think we should use it for better performance and.
- [x] **bug** - `minor` show-phtheme if ctl+c is fired there is some weirdness with the output causing returned terminal to have where spacing
- [x] **Theme fixes and issues**
  - [x] crystal theme is broken layout — replaced ambiguous-width glyphs (❖/✧/❄❅❆) with safe box-drawing chars (◆/»/╔══╗/╚══╝/▒)
  - [x] nebula theme is broken layout — replaced ambiguous-width glyphs (✹/✸/❇❈) with safe box-drawing chars (◆/»/╠══╪══╣/░)
  - [x] rust theme is broken layout — replaced ambiguous SectionChar ❖ with ◆
  - [x] SYNTAX, PARAMETERS, EXAMPLES only need 1 space after — fixed all section headers to emit 1 blank line (not 2)
  - [x] new-phwriter has the capability to change type, route, command, and cmdlet — SourceType eparam was already present; now surfaced clearly in help
  - [x] add SourceType to the show-phtheme — added -SourceType parameter (module|script|tool|plugin|cli|function|workflow), passed through to New-PHWriter
  - [x] outer border gradients — already implemented via -OuterBorder + -BorderGradient + -BorderCustomGradient
  - [x] add multiple types of outer border types — added -OuterBorderStyle (Rounded|Square|Double|Block|Simple) to New-PHWriter and Show-PHTheme
  - [x] main header title needs 1 space before and after — fixed header line to pad with 1 space before/after joined parts
  - [x] add TextSpacing option to show-phtheme — added -TextSpacing switch parameter to Show-PHTheme (passes through)
  - [x] the [incomplete entry — original text truncated]
- [x] **show-phpager** — now pulls from full theme schema: SectionChar for separators, HeaderChar for title prefix, SyntaxFg for footer key-hint color, AccentColor/BorderColor/HeaderFg/Bg/ParamDescFg for chrome colors

> [!NOTE]
> **Pad-AnsiString emoji PadChar error** — root cause was theme `BorderMiddle` containing emoji glyphs (e.g. 🔥).
> Fixed by replacing all emoji/ambiguous-width glyphs in broken themes with safe box-drawing chars.
> The `Pad-AnsiString` function itself is correct; the issue was upstream in theme definitions.

- [x] **My Goal** - a cross platform helper writer that can be use with all of my modules and tools, and other tools if they want to use powershell for that perpose. i want to dev to have full control to output how they want theme how they want and have the ability to customize the theme to their liking.
- [x] **READ** - extended-tui-knowleadge.md - some elements are to avoided for tear for tui
  - [x] **FIX** - remove all problematic glyphs from the theme and only use safe glyphs
- [x] **FIX** blaze theme error
- [x] **Customize-extend** - allow header to be gradient perhaps have a switch for -gradient and -customgradnet where user can specify.
- [x] for all themes i want to be able to optional put a border around the entire help output and have the border be a gradient, with custom gradient if specified
- [x] the parm name and description should be on the same line, for descriptions that are too long we can use the pager to scroll through the description unsure of the best way to allow the user to specify action.

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
