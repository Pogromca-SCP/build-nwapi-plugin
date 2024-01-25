# `Pogromca-SCP/build-nwapi-plugin`
[![GitHub release](https://flat.badgen.net/github/release/Pogromca-SCP/build-nwapi-plugin)](https://github.com/Pogromca-SCP/build-nwapi-plugin/releases/)
[![GitHub license](https://flat.badgen.net/github/license/Pogromca-SCP/build-nwapi-plugin)](https://github.com/Pogromca-SCP/build-nwapi-plugin/blob/main/LICENSE)
![GitHub dependents](https://flat.badgen.net/github/dependents-repo/Pogromca-SCP/build-nwapi-plugin)
![GitHub last commit](https://flat.badgen.net/github/last-commit/Pogromca-SCP/build-nwapi-plugin/main)

GitHub Action that builds and prepares artifacts for NwPluginAPI based plugin.

## Usage
### Inputs
| Input                    | Description                                                                                                    | Required | Default value          |
| ------------------------ | -------------------------------------------------------------------------------------------------------------- | -------- | ---------------------- |
| plugin-name              | Name of main plugin assembly/project to package.                                                               | true     |                        |
| refs-variable            | Name of game files references environment variable used in the project. Triggers game files download when set. | false    |                        |
| depot-downloader-version | Depot downloader version to use for game files download. Takes effect only when `refs-variable` is set.        | false    | 2.5.0                  |
| run-tests                | Whether or not the tests should be run for the project.                                                        | false    | true                   |
| initial-test-runs        | Amount of initial test runs. Takes effect only when `run-tests` is set to `true`.                              | false    | 3                      |
| dependencies             | List of assembly/project names to add into `dependencies.zip` file.                                            | false    | @()                    |
| bin-path                 | Binary files path pattern to use, `$` is replaced with assembly/project name.                                  | false    | /$/bin/Release/net48/$ |
| includes                 | Other non-project assemblies/files to add into `dependencies.zip` file (full paths).                           | false    | @()                    |
### Example
```yaml
name: Build my plugin

# ...

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
      uses: Pogromca-SCP/build-nwapi-plugin@v1
      with:
        plugin-name: MyPlugin
```
