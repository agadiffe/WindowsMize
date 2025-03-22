#=================================================================================================================
#                                          Power Options - Fast Startup
#=================================================================================================================

# control panel (icons view) > power options > choose what the power button do
# (control.exe /name Microsoft.PowerOptions /page pageGlobalSettings)

# default: Enabled

<#
.SYNTAX
    Set-FastStartup
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FastStartup
{
    <#
    .EXAMPLE
        PS> Set-FastStartup -State 'Disabled'
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
        $FastStartup = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\Session Manager\Power'
            Entries = @(
                @{
                    Name  = 'HiberbootEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Fast Startup' to '$State' ..."
        Set-RegistryEntry -InputObject $FastStartup
    }
}
