#=================================================================================================================
#                          Personnalization > Start > Show Account-Related Notifications
#=================================================================================================================

<#
.SYNTAX
    Set-StartShowAccountNotifications
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-StartShowAccountNotifications
{
    <#
    .EXAMPLE
        PS> Set-StartShowAccountNotifications -State 'Disabled'
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
        $StartAccountNotifications = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'Start_AccountNotifications'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - Show Account-Related Notifications' to '$State' ..."
        Set-RegistryEntry -InputObject $StartAccountNotifications
    }
}
