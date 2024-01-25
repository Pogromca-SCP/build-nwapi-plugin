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
    $files = New-Object System.Collections.Generic.List[string]

    if ($dependencies.Length -gt 0) {
        $dependencies = $dependencies | ForEach-Object -Process { "$workspacePath/$binPathPattern.dll".Replace("$", $_) }
        $files.AddRange($dependencies)
    }

    if ($includes -gt 0) {
        $includes = $includes | ForEach-Object -Process { "$workspacePath/$_" }
        $files.AddRange($includes)
    }
    
    Compress-Archive $files.ToArray() -DestinationPath D:/plugin/Artifacts/dependencies.zip
}
