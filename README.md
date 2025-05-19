# `Pogromca-SCP/build-nwapi-plugin`
[![GitHub release](https://flat.badgen.net/github/release/Pogromca-SCP/build-nwapi-plugin)](https://github.com/Pogromca-SCP/build-nwapi-plugin/releases/)
[![GitHub license](https://flat.badgen.net/github/license/Pogromca-SCP/build-nwapi-plugin)](https://github.com/Pogromca-SCP/build-nwapi-plugin/blob/main/LICENSE)
![GitHub dependents](https://flat.badgen.net/github/dependents-repo/Pogromca-SCP/build-nwapi-plugin)
![GitHub last commit](https://flat.badgen.net/github/last-commit/Pogromca-SCP/build-nwapi-plugin/main)

GitHub Action for [NwPluginAPI](https://github.com/northwood-studios/NwPluginAPI) or [LabAPI](https://github.com/northwood-studios/LabAPI) based plugin development. Performs project build, runs tests and uploads artifacts with zipped dependencies.

This action does not provide a .NET environment! You need to setup it on your own before running this action.

## Inputs
### `plugin-name`
Name of main plugin assembly/project to package. **This input is required!**

### `refs-variable `
Name of game files references environment variable used in the project. Triggers game files download when set. **Default: `$null`**.

### `depot-downloader-version`
Depot downloader version to use for game files download. Takes effect only when `refs-variable` is set. Check version compatibility table below for valid values. **Default: `3.4.0`**.

### `run-tests`
Whether or not the tests should be run for the project. **Default: `true`**.

### `initial-test-runs`
Amount of initial test runs. Takes effect only when `refs-variable` is set and `run-tests` is set to `true`. **Default: `3`**.

### `dependencies`
List of assembly/project names to add into `dependencies.zip` file. **Default: `@()`**.

### `bin-path`
Binary files path pattern to use, `$` is replaced with assembly/project name. **Default: `/$/bin/Release/net48/$`**.

### `includes`
Other non-project assemblies/files to add into `dependencies.zip` file (full paths). **Default: `@()`**.

### `configuration`
Project build configuration. Consider changing `bin-path` input value alongside this. **Default: `Release`**.

## Versions compatibility
| Action version | Supported depot downloader versions |
| -------------- | ----------------------------------- |
| 2.x.x          | >= 2.6.0                            |
| < 2.0.0        | < 2.6.0                             |

## Examples
### Minimal setup
```yaml
jobs:
  build:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup .NET
      uses: actions/setup-dotnet@v4
      with:
        dotnet-version: 8.0.x
        
    - name: Build, test and upload artifacts
      uses: Pogromca-SCP/build-nwapi-plugin@v2
      with:
        plugin-name: MyPlugin
```
### Minimal setup with game files download
```yaml
jobs:
  build:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup .NET
      uses: actions/setup-dotnet@v4
      with:
        dotnet-version: 8.0.x
        
    - name: Build, test and upload artifacts
      uses: Pogromca-SCP/build-nwapi-plugin@v2
      with:
        plugin-name: MyPlugin
        refs-variable: SL_REFERENCES # Name of your environment variable used to reference SCP:SL files
```
### With dependency projects and adjusted bin paths
```yaml
jobs:
  build:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup .NET
      uses: actions/setup-dotnet@v4
      with:
        dotnet-version: 8.0.x
        
    - name: Build, test and upload artifacts
      uses: Pogromca-SCP/build-nwapi-plugin@v2
      with:
        plugin-name: MyPlugin
        dependencies: MyPlugin.CoreLib,MyPlugin.Utils
        bin-path: /$/bin/Release/$ # Adjust bin path to match your project configuration
```
### With third-party dependencies
```yaml
jobs:
  build:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup .NET
      uses: actions/setup-dotnet@v4
      with:
        dotnet-version: 8.0.x
        
    - name: Build, test and upload artifacts
      uses: Pogromca-SCP/build-nwapi-plugin@v2
      with:
        plugin-name: MyPlugin
        includes: MyPlugin/bin/Harmony0.dll,README.md # Any file type can be added
```
### Without tests
```yaml
jobs:
  build:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup .NET
      uses: actions/setup-dotnet@v4
      with:
        dotnet-version: 8.0.x
        
    - name: Build and upload artifacts
      uses: Pogromca-SCP/build-nwapi-plugin@v2
      with:
        plugin-name: MyPlugin
        run-tests: false
```
