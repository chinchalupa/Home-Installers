function Export-PackageList {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [ValidateScript({ Test-Path $_ -IsValid })]
        [string]
        $path = '.\packages.config'
    )
    $chocolateyList = $(choco list -lo -r -y |ForEach-Object { "    <package id=`"$($_.SubString(0, $_.IndexOf("|")))`" version=`"$($_.SubString($_.IndexOf("|") + 1))`" />`n" })

@"
    <?xml version=`"1.0`" encoding=`"utf-8`"?>
    <packages>`n${chocolateyList}</packages>
"@ | Out-File -FilePath $path
}


