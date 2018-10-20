<#
.SYNOPSIS
    Installs all of the items in the .\packages.config by default.

.PARAMETER 
#>
function Install-PackageList {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        # The location of the config file
        [Parameter()]
        [System.IO.FileInfo]
        $PackageFileName = "$PSScriptRoot\..\packages.config"
    )
    $packageFileFullName = $PackageFileName.FullName

    if ($PSCmdlet.ShouldProcess($packageFileName, "choco Install")) {
        Invoke-Expression "choco install $PackageFileName -y"
    }
}
