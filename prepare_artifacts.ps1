param(
    # Name of plugin to pack
    [Parameter(Mandatory = $true)]
    [string] $pluginName,

    # Workspace path to use
    [Parameter(Mandatory = $true)]
    [string] $workspacePath,

    # Binary files path pattern to use '$' is replaced with assembly/project name
    [Parameter(Mandatory = $false)]
    [string] $binPathPattern = "/$/bin/Release/net48/$",

    # Additional dependencies to pack
    [Parameter(Mandatory = $false)]
    [string[]] $dependencies = @(),

    # Additional includes to pack
    [Parameter(Mandatory = $false)]
    [string[]] $includes = @()
)

# Prepare artifacts
New-Item -ItemType Directory -Force -Path D:/plugin/Artifacts
Copy-Item "$workspacePath/$binPathPattern.dll".Replace("$", $pluginName) -Destination D:/plugin/Artifacts

if ($dependencies.Length -gt 0 -or $includes.Length -gt 0) {
    [Collections.Generic.List[string]] $assemblies = $dependencies | ForEach-Object -Process { "$workspacePath/$binPathPattern.dll".Replace("$", $_) }
    $includes = $includes | ForEach-Object -Process { "$workspacePath/$_" }
    $assemblies.AddRange($includes)
    Compress-Archive $assemblies.ToArray() -DestinationPath D:/plugin/Artifacts/dependencies.zip
}
