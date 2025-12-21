param(
    # Name of environment variable to set up
    [Parameter(Mandatory = $false)]
    [string] $referencesVariable = $null,

    # Depot downloader version to use
    [Parameter(Mandatory = $false)]
    [string] $depotDownloaderVersion = "3.4.0",

    # Project build configuration
    [Parameter(Mandatory = $false)]
    [string] $config = "Release"
)

# Setup environment
if ($IsWindows) {
    $pluginPath = "D:/a/plugin"
} elseif ($IsLinux) {
    $pluginPath = "/home/runner/work/plugin"
} else {
    throw "Action is running on unsupported system, only x64 Windows and Linux are supported. Operation aborted."
}

New-Item -ItemType Directory -Force -Path $pluginPath

if (-not [string]::IsNullOrWhiteSpace($referencesVariable)) {
    Set-Item "Env:\$referencesVariable" -Value "$pluginPath/SCPSL_REFERENCES/SCPSL_Data/Managed"

    # Setup depot downloader
    New-Item -ItemType Directory -Force -Path "$pluginPath/DepotDownloader"
    $url = "https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_$depotDownloaderVersion/DepotDownloader"

    if ($IsWindows) {
        $url = "$url-framework.zip"
    } else {
        $url = "$url-linux-x64.zip"
    }

    Invoke-WebRequest -Uri $url -OutFile "$pluginPath/depotdownloader.zip"
    Expand-Archive -Path "$pluginPath/depotdownloader.zip" -PassThru -DestinationPath "$pluginPath/DepotDownloader"
    
    # Download SCP: Secret Laboratory
    New-Item -ItemType Directory -Force -Path "$pluginPath/SCPSL_REFERENCES"
    $exePath = "$pluginPath/DepotDownloader/DepotDownloader"

    if ($IsWindows) {
        $exePath = "$exePath.exe"
    }

    Start-Process -NoNewWindow -Wait -FilePath $exePath -WorkingDirectory "$pluginPath/DepotDownloader" -ArgumentList "-app 996560","-dir $pluginPath/SCPSL_REFERENCES"
}

# Build project
dotnet restore
dotnet build --no-restore --configuration $config
