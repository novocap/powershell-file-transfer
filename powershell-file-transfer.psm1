$WarningPreference = "Inquire"
$ErrorActionPreference = "Inquire"

# Get template content and all folders modules
[String] $moduleTemplate = Get-Content -Path $PSScriptRoot/Modules/Template/Template.psm1 -Raw
$modulesToImport = @( Get-ChildItem -Path $PSScriptRoot/Modules -Directory | Where-Object {$_.FullName -notlike "*Template*" } )

# Create & import all modules
foreach ($folderModule in $modulesToImport) {
    [String] $itemModuleName = $folderModule.BaseName + ".psm1"
    [String] $itemManifiest = $folderModule.FullName + "/" + $folderModule.BaseName + ".psd1"
    [String[]] $publicFunctionsToExport = @( (Get-ChildItem -Path ($folderModule.FullName + "/Public")).BaseName )

    New-Item -Path $folderModule.FullName -Name $itemModuleName -ItemType File -Value $moduleTemplate -Force
    New-ModuleManifest `
        -Path $itemManifiest `
        -RootModule $itemManifiest `
        -CompanyName "Novocap S.A." `
        -Copyright "(c) 2021 Novocap S.A. All rights reserved." `
        -Author "Scripting Team" `
        -ModuleVersion "0.0.0.0" `
        -CompatiblePSEditions @("Desktop","Core") `
        -FunctionsToExport $publicFunctionsToExport `
        -Description "Import $itemModuleName" `
        -PassThru

    $moduleToImportPath = @( Get-ChildItem -Path $folderModule.FullName -File -Filter "*.psm1" -ErrorAction SilentlyContinue | Sort-Object Name )

    foreach ($module in $moduleToImportPath)
    { Import-Module -Name $module.FullName -Force -Verbose }
}
