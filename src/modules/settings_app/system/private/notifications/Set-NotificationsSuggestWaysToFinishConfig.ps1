#=================================================================================================================
#                     System > Notifications > Suggest Ways To Finish Setting Up This Device
#=================================================================================================================

# Suggest ways to get the most out of Windows and finish setting up this device

<#
.SYNTAX
    Set-NotificationsSuggestWaysToFinishConfig
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NotificationsSuggestWaysToFinishConfig
{
    <#
    .EXAMPLE
        PS> Set-NotificationsSuggestWaysToFinishConfig -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $NotificationsSuggestWaysToFinishConfig = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement'
            Entries = @(
                @{
                    Name  = 'ScoobeSystemSettingEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Notifications - Suggest Ways To Finish Setting Up Device' to '$State' ..."
        Set-RegistryEntry -InputObject $NotificationsSuggestWaysToFinishConfig
    }
}
