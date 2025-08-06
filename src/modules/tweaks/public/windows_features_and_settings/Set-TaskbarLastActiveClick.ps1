#=================================================================================================================
#                                           Taskbar - Last Active Click
#=================================================================================================================

# You can hold the Ctrl key down while clicking a taskbar button to view the last active window
# and then keep clicking with Ctrl held to cycle through each of that app's open windows.

# Enabling the "last active click" feature remove the extra step of holding down the Ctrl key.

<#
.SYNTAX
    Set-TaskbarLastActiveClick
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarLastActiveClick
{
    <#
    .EXAMPLE
        PS> Set-TaskbarLastActiveClick -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: delete (default)
        $TaskbarLastActiveClick = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'Disabled'
                    Name  = 'LastActiveClick'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar - Last Active Click' to '$State' ..."
        Set-RegistryEntry -InputObject $TaskbarLastActiveClick
    }
}
