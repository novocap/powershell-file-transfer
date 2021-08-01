function New-FileTransfer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]
        $OriginPath,
        [Parameter(Mandatory)]
        [String]
        $DestinationPath,
        [Parameter(Mandatory)]
        [String]
        $FileNameToCopy
    )

    if ($null -ne $OriginPath){
        $originPath = (Get-Item -Path $OriginPath).FullName
    }

    if ($null -ne $DestinationPath){
        $destinationPath = (Get-Item -Path $DestinationPath).FullName
    }

    if ($null -ne $FileToCopy){
        $fileNameToCopy = (Get-Item -Path $FileNameToCopy).FullName
    }

    $credential = Get-Credential
    $originSVR = New-PSDrive -Name "OriginSVR" -Root $originPath -PSProvider "FileSystem" -Credential $credential
    $fileToCopy = Get-ChildItem -Path $originSVR.Root | Where-Object {$_.Name -eq $fileNameToCopy}

    try {
        Copy-Item -Path $fileToCopy.FullName -Destination $destinationPath

        $fileInDestination = Get-ChildItem -Path $destinationPath | Where-Object {$_.Name -eq $fileToCopy.Name}

        [String] $originFileHash = (Get-FileHash -Path $fileToCopy.FullName -ErrorAction SilentlyContinue).Hash
        [String] $destinationFileHash = (Get-FileHash -Path $fileInDestination.FullName -ErrorAction SilentlyContinue).Hash
            
        if ($originFileHash -eq $destinationFileHash) {
                Write-Host "OK, the integrity is correct"
        }
        else {
                [String] $differentHashError = ("[ERROR] - File integrity error: {0}" -f $DestinationFile)
                Write-Error -Message $differentHashError -ErrorAction Stop
        }
    }
    # Catch the error when the file is being used 
    catch [Microsoft.PowerShell.Commands.WriteErrorException] { 
        Write-Host "Error, the file es being used"
    }
}
