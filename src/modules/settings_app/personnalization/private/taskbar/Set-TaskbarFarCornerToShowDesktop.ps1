#=================================================================================================================
#         Personnalization > Taskbar Behaviors > Select The Far Corner Of The Taskbar To Show The Desktop
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarFarCornerToShowDesktop
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarFarCornerToShowDesktop
{
    <#
    .EXAMPLE
        PS> Set-TaskbarFarCornerToShowDesktop -State 'Disabled'
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
        $TaskbarFarCornerShowDesktop = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'TaskbarSd'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar - Select The Far Corner Of The Taskbar To Show The Desktop' to '$State' ..."
        Set-RegistryEntry -InputObject $TaskbarFarCornerShowDesktop
    }
}
