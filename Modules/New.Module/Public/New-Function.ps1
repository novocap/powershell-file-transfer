function New-Function {
    param ()

    [String] $name = Get-FunctionName
    Write-Host "Hello from $name"
}
