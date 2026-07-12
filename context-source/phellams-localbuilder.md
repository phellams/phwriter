## **Build**

**Phellams** modules are built using either the [**phellams-automator**](https://gitlab.com/phellams/phellams-automator) Docker image paired with the [**Automator-Devops**](https://gitlab.com/phellams/automator-devops) scripts to build and publish modules to:

* [**PowerShell Gallery (PSGallery)**](https://www.powershellgallery.com/packages/fastfsc)
* [**Chocolatey**](https://community.chocolatey.org/profiles/sgkens)
* [**GitHub Packages**](https://gitlab.com/phellams/pwsl/-/packages?type=NuGet&orderBy=name&sort=desc)

If you prefer not to use the Docker image, you can run the [**automator-devops**](https://gitlab.com/phellams/automator-devops) scripts locally using **PowerShell 7.x**.

Dependencies must be installed manually, either from the [PowerShell Gallery](https://www.powershellgallery.com) or by cloning the module directly from the GitHub/GitLab source repository (see below).

---

### `localbuilder` Script Parameters

All build metadata is stored in the `./build_config.json` file. See [**Build Config**](./templates/build_config.template.json) for additional information.

```text
localbuilder  [-Automator (switch)]
              [-build_dotnet_lib (switch)]
              [-PhWriter (switch)]
              [-Pester (switch)]
              [-Build (switch)] 
              [-PsGal (switch)]
              [-Nuget (switch)] 
              [-ChocoNuSpec (switch)] 
              [-ChocoPackage (switch)] 
              [-ChocoPackageWindows (switch)]
              [-Cleanup (switch)]
```

| Parameter                                   | Description                                                                                                                                                                          |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **`-Automator`**                            | Builds using the `phellams-automator` Docker image. If not specified, the script will use the local PowerShell installation. All dependencies must be installed locally (see below). |
| **`-build_dotnet_lib`**                     | Calls `build-dotnet-library.ps1`, which runs `dotnet build` and `dotnet pack` to build and package .NET libraries (`.nupkg`). *(WIP – functional but requires refinement.)*          |
| **`-PhWriter`**                             | Generates the `phwriter-metadata.ps1` file using the `phwriter` module.                                                                                                              |
| **`-Pester`**                               | Calls `test-pester-before-build.ps1`, which runs `Invoke-Pester` from the `Pester` module.                                                                                           |
| **`-Sa`**                                   | Calls `test-sa-before-build.ps1`, which runs `Invoke-ScriptAnalyzer` from the `PSScriptAnalyzer` module.                                                                             |
| **`-Build`**                                | Calls `build-module.ps1` from the `psmpacker` module. Copies the built module to the `dist` folder and generates the `VERIFICATION.txt` file.                                        |
| **`-Nuget`**                                | Calls `build-package-generic-nuget.ps1`, which runs `New-NuspecPackageFile` and `New-NupkgPackage` from the `nupsforge` module.                                                      |
| **`-PsGal`**                                | Calls `build-package-psgallery.ps1`, which runs `New-NuspecPackageFile` from the `nupsforge` module for PowerShell Gallery publishing.                                               |
| **`-ChocoNuSpec`**                          | Calls `build-nuspec-choco.ps1`, which runs `New-ChocoNuspecFile` from the `nupsforge` module.                                                                                        |
| **`-ChocoPackage`** *(Docker only)*         | Calls `build-package-choco.sh` (Linux only). Runs `choco pack` and `choco push` using the `choco/choco:latest` Docker image.                                                         |
| **`-ChocoPackageWindows`** *(Windows only)* | Calls `build-package-choco-windows.ps1`, which runs `New-ChocoNuspecFile` and `New-ChocoPackage` from the `nupsforge` module. **Requires Chocolatey to be installed.**               |

---

### Depenedencies Modules(linux/Winx64)

  * [Pester](https://github.com/pester/Pester) `ONLY IF USING PESTER TO TEST YOUR MODULES`
  * [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) `ONLY IF USING PSSA TO TEST YOUR MODULES`
  * [colorconsole](https://gitlab.com/phellams/colorconsole)
  * [tadpol](https://gitlab.com/phellams/tadpol)
  * [GetAutoVersion](https://gitlab.com/phellams/phellams-utils/semver/Get-GitAutoVersion)
  * [quicklog](https://gitlab.com/phellams/quicklog)
  * [shelldock](https://gitlab.com/phellams/shelldock)
  * [psmpacker](https://gitlab.com/phellams/psmpacker)
  * [nupsforge](https://gitlab.com/phellams/nupsforge)
  * [csverify](https://gitlab.com/phellams/csverify)
  * [phwriter](https://gitlab.com/phellams/phwriter) `ONLY IF USING PHWRITER TO GENERATE LINUX MAN PAGES HELP FILES`
  * [gemcommander](https://gitlab.com/phellams/gemcommander) `ONLY IF BUILDING JEKYLL GEM THEMES`

### Dependecies Binaries(linux/Winx64)
  * [git](https://git-scm.com/)
  * [choco](https://chocolatey.org/)
  * [nuget](https://www.nuget.org/downloads) v6.x

---

### Building Using Automator

Build the module locally using the **phellams-automator** Docker image.

> **Note:** Chocolatey build and publish requires the choco Docker image to be built and published.

```powershell
# -PHWriter for phwriter metadata
# -Sa for scriptanalyzer
# -Pester for pester tests
pwsh -c ./automator-devops/localbuilder.ps1 -Automator -Build -Nuget -ChocoNuSpec -ChocoPackage -PsGal -Cleanup
```

---

### Building Using PowerShell 7.x

> **Note (Windows):** Chocolatey can be installed easily via [https://chocolatey.org/install](https://chocolatey.org/install).
> **Note (Non-Windows):** Chocolatey build and publish requires the choco Docker image if not running on Windows.

```powershell
# -PHWriter for phwriter metadata
# -Sa for scriptanalyzer
# -Pester for pester tests
pwsh -c ./automator-devops/localbuilder.ps1 -Build -Nuget -ChocoNuSpec -ChocoPackage -PsGal -Cleanup
```