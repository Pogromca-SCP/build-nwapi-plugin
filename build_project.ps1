param(
    # Name of environment variable to set up
    [Parameter(Mandatory = $false)]
    [string] $referencesVariable = $null,

    # Depot downloader version to use
    [Parameter(Mandatory = $false)]
    [string] $depotDownloaderVersion = "2.7.3",

    # Project build configuration
    [Parameter(Mandatory = $false)]
    [string] $config = "Release"
)

# Setup environment
New-Item -ItemType Directory -Force -Path D:/a/plugin

if (-not [string]::IsNullOrWhiteSpace($referencesVariable)) {
    Set-Item "Env:\$referencesVariable" -Value "D:/a/plugin/SCPSL_REFERENCES/SCPSL_Data/Managed"

    # Setup depot downloader
    New-Item -ItemType Directory -Force -Path D:/a/plugin/DepotDownloader
    Invoke-WebRequest -Uri "https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_$depotDownloaderVersion/DepotDownloader-framework.zip" -OutFile "D:/a/plugin/depotdownloader.zip"
    Expand-Archive -Path D:/a/plugin/depotdownloader.zip -PassThru -DestinationPath D:/a/plugin/DepotDownloader
    
    # Download SCP: Secret Laboratory
    New-Item -ItemType Directory -Force -Path D:/a/plugin/SCPSL_REFERENCES
    Start-Process -NoNewWindow -Wait -FilePath "D:/a/plugin/DepotDownloader/DepotDownloader.exe" -WorkingDirectory "D:/a/plugin/DepotDownloader" -ArgumentList "-app 996560","-dir D:/a/plugin/SCPSL_REFERENCES"
}

# Build project
dotnet restore
dotnet build --no-restore --configuration $config
