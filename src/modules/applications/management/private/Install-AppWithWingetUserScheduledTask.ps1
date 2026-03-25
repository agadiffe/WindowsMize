#=================================================================================================================
#                               Install Application With Winget User Scheduled Task
#=================================================================================================================

<#
.SYNTAX
    Install-AppWithWingetUserScheduledTask
        [-Id] <string>
        [-RunAsUser] <string>
        [[-Argument] <string[]>]
        [<CommonParameters>]
#>

function Install-AppWithWingetUserScheduledTask
{
    <#
    .DESCRIPTION
        If "winget --scope=User" is launched within an elevated powershell session on a Standard account,
        the application is installed for the admin account instead of the current logged-on user.

    .EXAMPLE
        PS> $InstallOptions = @(
                '--exact'
                '--accept-source-agreements'
                '--accept-package-agreements'
                '--silent'
                '--disable-interactivity'
                '--source=winget'
                '--scope=User'
            )
        PS> Install-AppWithWingetUserScheduledTask -Id 'MullvadVPN.MullvadBrowser' -RunAsUser 'Groot' -Argument $InstallOptions
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Id,

        [Parameter(Mandatory)]
        [string] $RunAsUser,

        [string[]] $Argument
    )

    process
    {
        $TaskPath = '\'
        $TaskName = "TempTaskName-$(New-Guid)"
        $TaskTriggerParam = @{
            ClassName = 'MSFT_TaskRegistrationTrigger' # at task creation/modification
            Namespace = 'Root/Microsoft/Windows/TaskScheduler'
        }
        $TaskTrigger = Get-CimClass @TaskTriggerParam -Verbose:$false
        $TaskActionParam = @{
            Execute  = 'powershell.exe'
            Argument = "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command
                ""winget.exe install --id $Id $($InstallOptions.ForEach({ $_ }))"""
        }
        $TaskAction = New-ScheduledTaskAction @TaskActionParam
        $TaskPrincipal = New-ScheduledTaskPrincipal -UserId $RunAsUser
        $TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries

        $ScheduledTaskParam = @{
            TaskName  = $TaskName
            TaskPath  = $TaskPath
            Action    = $TaskAction
            Trigger   = $TaskTrigger
            Principal = $TaskPrincipal
            Settings  = $TaskSettings
        }

        Register-ScheduledTask @ScheduledTaskParam -Verbose:$false | Out-Null

        while ((Get-ScheduledTask -TaskPath $TaskPath -TaskName $TaskName).State -eq 'Running')
        {
            Start-Sleep -Seconds 0.1
        }

        Unregister-ScheduledTask -TaskPath $TaskPath -TaskName $TaskName -Confirm:$false

        # App is launched after installation. Close it.
        $AppToClose = @{
            'Proton.ProtonPass' = 'ProtonPass'
        }
        if ($AppToClose.Keys -contains $Id)
        {
            Stop-Process -Name $AppToClose[$Id] -Force -ErrorAction 'SilentlyContinue'
        }
    }
}
