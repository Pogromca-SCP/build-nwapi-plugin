param(
    # Name of plugin to pack
    [Parameter(Mandatory = $true)]
    [string] $pluginName,

    # Workspace path to use
    [Parameter(Mandatory = $true)]
    [string] $workspacePath,

    # Whether or not the tests should run
    [Parameter(Mandatory = $false)]
    [bool] $runTests = $true,

    # Binary files path pattern to use '$' is replaced with assembly/project name
    [Parameter(Mandatory = $false)]
    [string] $binPathPattern = "/$/bin/Release/net48/$",

    # Additional dependencies to pack
    [Parameter(Mandatory = $false)]
    [string[]] $dependencies = @()
)

# Run tests
if ($runTests) {
    dotnet test --no-build --verbosity normal
}

# Prepare artifacts
New-Item -ItemType Directory -Force -Path D:/plugin/Artifacts
Copy-Item "$workspacePath/$binPathPattern.dll".Replace("$", $pluginName) -Destination D:/plugin/Artifacts

if ($dependencies.Length -gt 0) {
    $assemblies = $dependencies | ForEach-Object -Process { "$workspacePath/$binPathPattern.dll".Replace("$", $_) }
    Compress-Archive $assemblies -DestinationPath D:/plugin/Artifacts/dependencies.zip
}