#=================================================================================================================
#                                       Personnalization > Taskbar > Resume
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarResumeAppNotif
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarResumeAppNotif
{
    <#
    .EXAMPLE
        PS> Set-TaskbarResumeAppNotif -State 'Disabled'
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
        $TaskbarResumeAppNotif = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'IsEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar - Resume App Notif' to '$State' ..."
        Set-RegistryEntry -InputObject $TaskbarResumeAppNotif
    }
}
