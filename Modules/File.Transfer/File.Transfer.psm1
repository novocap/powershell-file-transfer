# Get functions and types to import
$scriptsToConfigure = @(Get-ChildItem -Path $PSScriptRoot -File -Filter "*.ps1" -ErrorAction SilentlyContinue)
$classesToImport = @( Get-ChildItem -Path $PSScriptRoot\Classes -File -Filter "*.cs" -ErrorAction SilentlyContinue | Sort-Object Name )
$privateFunctionsToImport = @( Get-ChildItem -Path $PSScriptRoot\Private -File -Filter "*.ps1" -ErrorAction SilentlyContinue | Sort-Object Name )
$publicFunctionsToImport = @( Get-ChildItem -Path $PSScriptRoot\Public -File -Filter "*.ps1" -ErrorAction SilentlyContinue | Sort-Object Name )
$scriptsToImport = $privateFunctionsToImport + $publicFunctionsToImport

# Special Module's configurations
foreach ($script in $scriptsToConfigure) {
    try {
        if($script.BaseName -eq $script.Directory.Name)
        { & $script.FullName }
    }
    catch {
        Write-Warning -Message "Failed to configure the module with $($script.FullName) script: $_"
        return
    }
}

# Add types based on C# Classes
foreach ($class in $classesToImport) {
    try {
        $classType = Get-Content -Path $class.FullName -Raw
        Add-Type -TypeDefinition $classType
    }
    catch {
        Write-Error -Message "Failed to import the class $($class.FullName): $_"
        return
    }
}

# Import functions
foreach ($function in $scriptsToImport) {
    try { . $function.FullName }
    catch {
        Write-Error -Message "Failed to import the script $($function.FullName): $_"
        return
    }
}

# Export public functions
Export-ModuleMember -Function $publicFunctionsToImport.BaseName
