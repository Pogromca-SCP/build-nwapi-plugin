param(
    # Name of environment variable to set up
    [Parameter(Mandatory = $false)]
    [string] $referencesVariable = $null,

    # Depot downloader version to use
    [Parameter(Mandatory = $false)]
    [string] $depotDownloaderVersion = "2.5.0"
)

# Setup environment
if (-not [string]::IsNullOrWhiteSpace($referencesVariable)) {
    Set-Item "Env:\$referencesVariable" -Value "D:/plugin/SCPSL_REFERENCES/SCPSL_Data/Managed"
}

# Setup depot downloader
New-Item -ItemType Directory -Force -Path D:/plugin
New-Item -ItemType Directory -Force -Path D:/plugin/DepotDownloader
Invoke-WebRequest -Uri "https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_$depotDownloaderVersion/depotdownloader-$depotDownloaderVersion.zip" -OutFile "D:/plugin/depotdownloader.zip"
Expand-Archive -Path D:/plugin/depotdownloader.zip -PassThru -DestinationPath D:/plugin/DepotDownloader

# Download SCP: Secret Laboratory
New-Item -ItemType Directory -Force -Path D:/plugin/SCPSL_REFERENCES
Start-Process -NoNewWindow -Wait -FilePath "D:/plugin/DepotDownloader/DepotDownloader.exe" -WorkingDirectory "D:/plugin/DepotDownloader" -ArgumentList "-app 996560","-dir D:/plugin/SCPSL_REFERENCES"

# Build project
dotnet restore
dotnet build --no-restore --configuration Release
