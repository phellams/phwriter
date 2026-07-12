## **API Reference**

### *💲New-SimpleBar*

Core rendering engine. Generates static string representations of progress intervals with precise structural and color formatting.

**🔹Sytax:**

```
New-SimpleBar [[-Brackets] <String[]>] [-Fill] <Int32> [-Width <Int32>] 
              [-FillChar <Char>] [-EmptyChar <Char>] [-BorderStyle <String>] 
              [-ColorPalette <Hashtable>] [-PercentagePosition <String>] 
              [-ColorMode <String>] [-ColorThresholds <Hashtable>] 
              [-GradientStart <Int32[]>] [-GradientEnd <Int32[]>] 
              [<CommonParameters>]`
```

**🔹Parameters**

| **Parameter** | **Type** | **Required** | **Default** | **Validation** | **Description** |
| --- | --- | --- | --- | --- | --- |
| `Brackets` | `String[]` | False | `@('[', ']')` | None | Cap strings for the left and right boundaries. |
| `Fill` | `Int32` | True | None | `0-100` | The completion percentage. Drives internal character counts. |
| `Width` | `Int32` | False | `20` | `> 2` | The absolute total character length of the generated string output (excluding ANSI escape codes). |
| `Height` | `Int32` | False | `1` | `> 0` | The number of identical vertical lines returned. Always outputs as a single string joined by newlines. |
| `FillChar` | `Char` | False | `█` (`[char]9608`) | None | The character populating the completed segment. |
| `EmptyChar` | `Char` | False | `-` | None | The character populating the remaining segment. |
| `ColorPalette` | `Hashtable` | False | `@{}` | None | Mappable keys include `Fill`, `Empty`, `Brackets`, and `Border`. Values are ANSI SGR sequence strings. |
| `PercentagePosition` | `String` | False | `None` | Set | `None`, `Center`, `Start`, `End`, `Before`, `After`. Defines relative text injection. |
| `ColorMode` | `String` | False | `Solid` | Set | `Solid`, `Conditional`, `Gradient`. Defines the logical application of ANSI sequences to the filled segment. |
| `ColorThresholds` | `Hashtable` | False | Map | None | Map of integer thresholds (max %) to ANSI SGR sequences. Used when `ColorMode` is `Conditional`. |
| `GradientStart` | `Int32[]` | False | `@(255,0,0)` | None | Array of `R, G, B` integers defining the 0% index color. Used when `ColorMode` is `Gradient`. |
| `GradientEnd` | `Int32[]` | False | `@(0,255,0)` | None | Array of `R, G, B` integers defining the 100% index color. Used when `ColorMode` is `Gradient`. |
| `BorderStyle` | `String` | False | `None` | Set | `None`, `Thin`, `Double`, `Rounded`. Applies an architectural wrap around the bar. |


**🔻Outputs**

`System.String`

**SGR** Sequences Strings examples: 

 - Red with background blue and bold `38;5;196;48;1`



---