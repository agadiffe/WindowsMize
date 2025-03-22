#=================================================================================================================
#                                          Test Defender Notifs Enabled
#=================================================================================================================

<#
.SYNTAX
    Test-DefenderNotifsEnabled
        [-Name] {VirusAndThreat | Account}
        [<CommonParameters>]
#>

function Test-DefenderNotifsEnabled
{
    <#
    .EXAMPLE
        PS> Test-DefenderNotifsEnabled -Name 'VirusAndThreat'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('VirusAndThreat', 'Account')]
        [string] $Name
    )

    process
    {
        $NotifsRegPath, $NotifsRegEntries = switch ($Name)
        {
            'VirusAndThreat'
            {
                'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection',
                @(
                    'SummaryNotificationDisabled'
                    'FilesBlockedNotificationDisabled'
                    'NoActionNotificationDisabled'
                )
            }
            'Account'
            {
                'HKEY_CURRENT_USER\Software\Microsoft\Windows Defender Security Center\Account protection',
                @(
                    'DisableDynamiclockNotifications'
                    'DisableWindowsHelloNotifications'
                )
            }
        }

        $RegItems = (Get-ItemProperty -Path "Registry::$NotifsRegPath" -ErrorAction 'SilentlyContinue').PSObject.Properties |
            Where-Object -FilterScript { $NotifsRegEntries -contains $_.Name -and $_.Value -eq 0 }

        [bool]$RegItems.Count
    }
}
