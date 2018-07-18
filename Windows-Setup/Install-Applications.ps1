function Update-Applications {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet('Install', 'Upgrade')]
        [string]
        $Action,

        [ValidateSet('BaseTools', 'DeveloperTools', 'CryptoTools', 'LanguageTools', 'MediaTools', 'WindowsTools', 'AmazonTools', 'GamingTools')]
        [string[]]
        $ToolSuites,

        [string[]]
        $ExcludeList,

        [switch]
        $AllSuites,

        [switch]
        $SetupScheduledTask
    )

    $BaseTools = 'geforce-game-ready-driver', 'firefox', 'googlechrome', '7zip', 'slack'
    $DeveloperTools = 'vim', 'git', 'notepadplusplus', 'openssh', 'putty', 'vscode', 'autohotkey.portable', 'sourcetree', 'poshgit'
    $CryptoTools = 'electrum', 'gpg4win'
    $LanguageTools = 'python', 'rust'
    $MediaTools = 'vlc'
    $WindowsTools = 'dotnetcore-sdk', 'azure-cli'
    $AmazonTools = 'awscli'
    $GamingTools = 'steam'

    # Install Suites
    $packages = @()
    if ($AllSuites) {
        $ToolSuites = (Get-Item variable:*Tools).Name
    }
    $ToolSuites |ForEach-Object {
        $packages += (Get-Item variable:$_).Value
    }

    $packages = $packages |Where-Object { $ExcludeList -notcontains $_ }

    Invoke-Expression "choco $Action $($packages -join ' ') -y"

    if ($SetupScheduledTask) {
        $toolSuiteString = $ToolSuites -join ','
        $act = New-ScheduledTaskAction -Execute "Powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -command '& {. `"$PSScriptRoot\Install-Applications.ps1`"; Update-Applications -Action Upgrade -ToolSuites `"$toolSuiteString`";}'"

        $trigger = New-ScheduledTaskTrigger -Daily -At 8am


        Register-ScheduledTask -Action $act -Trigger $trigger -TaskName "UpdateApplications" -Description "Updates all apps on the system via Chocolatey"
    }
}

