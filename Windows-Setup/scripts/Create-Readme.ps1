function Create-Readme {
    [CmdletBinding()] param ()
    Import-Module .\Windows-Installer.psd1 -Force

    #Copy-Item -Path .\README.template.md .\README.md -Force

    return (Get-Module Windows-Installer).ExportedCommands.Keys |% { return (Get-Help -Name $_) }
}