$WarningPreference = "Inquire"

# Get modules from Modules directory
[String[]] $modulesToImport = @( Get-ChildItem -Path $PSScriptRoot\Modules -Directory ).FullName

# Import all modules
foreach ($directoryModule in $modulesToImport) {
    $moduleScriptPath = @( Get-ChildItem -Path $directoryModule -File -Filter "*.psm1" -ErrorAction SilentlyContinue | Sort-Object Name )

    foreach ($module in $moduleScriptPath.FullName)
    { Import-Module -Name $module -Force -Verbose }
}
