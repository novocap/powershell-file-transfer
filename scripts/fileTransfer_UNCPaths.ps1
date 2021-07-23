$credOrigen = Get-Credential

$rutaOrigen = "\\ave-svr-bk01\c$\Inventario\Avellaneda"

$svrOrigen = New-PSDrive -Name "Origen" -Root $rutaOrigen -PSProvider "FileSystem" -Credential $credOrigen

$rutaDestino = "\\novocap.com\Payroll"

$nombreArchivoACopiar = "Prueba.docx"

$archivoACopiar = Get-ChildItem -Path $svrOrigen.Root | Where-Object {$_.Name -eq $nombreArchivoACopiar}

try {
    
    Copy-Item -Path $archivoACopiar.FullName -Destination $rutaDestino

    $archivoEnDestino = Get-ChildItem -Path $rutaDestino | Where-Object {$_.Name -eq $archivoACopiar.Name}

    [String] $hashArchivoOrigen = (Get-FileHash -Path $archivoACopiar.FullName -ErrorAction SilentlyContinue).Hash
    [String] $hashArchivoDestino = (Get-FileHash -Path $archivoEnDestino.FullName -ErrorAction SilentlyContinue).Hash
        
    if ($hashArchivoOrigen -eq $hashArchivoDestino) {
           Write-Host "OK, la integridad del archivo es correcta"
    }
    else {
         [String] $differentHashError = ("[ERROR] - File integrity error: {0}" -f $DestinationFile)
         Write-Error -Message $differentHashError -ErrorAction Stop
    }
}

# Catch the error when the file is being used 
catch [Microsoft.PowerShell.Commands.WriteErrorException] { 
    Write-Host "Error, el archivo se encuentra en uso"
}
