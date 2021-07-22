$WarningPreference = "Inquire"

# Get functions and types to import
$classesToImport = @( Get-ChildItem -Path $PSScriptRoot\Classes -File -Filter "*.cs" -ErrorAction SilentlyContinue | Sort-Object Name )
$privateFunctionsToImport = @( Get-ChildItem -Path $PSScriptRoot\Private -File -Filter "*.ps1" -ErrorAction SilentlyContinue | Sort-Object Name )
$publicFunctionsToImport = @( Get-ChildItem -Path $PSScriptRoot\Public -File -Filter "*.ps1" -ErrorAction SilentlyContinue | Sort-Object Name )
$scriptsToImport = $privateFunctionsToImport + $publicFunctionsToImport

# Add types based on C# Classes
foreach ($class in $classesToImport) {
    try {
        $classType = Get-Content -Path $class.FullName -Raw
        Add-Type -TypeDefinition $classType
    }
    catch {
        Write-Warning -Message "Failed to import the class $($class.FullName): $_"
        return
    }
}

# Import functions
foreach ($script in $scriptsToImport) {
    try { . $script.FullName }
    catch {
        Write-Warning -Message "Failed to import script $($script.FullName): $_"
        return
    }
}

# Export public functions
Export-ModuleMember -Function $publicFunctionsToImport.BaseName
