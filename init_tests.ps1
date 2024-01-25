param(
    # Name of environment variable
    [Parameter(Mandatory = $false)]
    [AllowEmptyString()]
    [string] $referencesVariable = $null,

    # Amount of initial test runs
    [Parameter(Mandatory = $false)]
    [byte] $initialRuns = 3
)

if ([string]::IsNullOrWhiteSpace($referencesVariable)) {
    exit 0
}

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = "D:/a/plugin/SCPSL_REFERENCES/LocalAdmin.exe"
$psi.Arguments = "7777"
$psi.WorkingDirectory = "D:/a/plugin/SCPSL_REFERENCES/"
$psi.UseShellExecute = $false
$psi.RedirectStandardInput = $true

# Make first server run to initialize config files
$pr = [System.Diagnostics.Process]::Start($psi)
Start-Sleep -s 5
$pr.StandardInput.WriteLine("yes")
Start-Sleep -s 2
$pr.StandardInput.WriteLine("keep")
Start-Sleep -s 2
$pr.StandardInput.WriteLine("global")
Start-Sleep -s 60
$pr.StandardInput.WriteLine("exit")
Start-Sleep -s 2

# Make initial test runs (few first runs on new machine always fail due to some weird SCP:SL spaghetti)
for ($i = 0; $i -lt $initialRuns; $i++) {
    dotnet test --no-build --verbosity quiet
    Start-Sleep -s 2
}

exit 0
