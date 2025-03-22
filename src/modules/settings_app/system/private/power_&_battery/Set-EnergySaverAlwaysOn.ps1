#=================================================================================================================
#                        System > Power & Battery > Energy Saver > Always Use Energy Saver
#=================================================================================================================

<#
.SYNTAX
    Set-EnergySaverAlwaysOn
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-EnergySaverAlwaysOn
{
    <#
    .EXAMPLE
        PS> Set-EnergySaverAlwaysOn -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 2 (default)
        $EnergySaver = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\Power'
            Entries = @(
                @{
                    Name  = 'EnergySaverState'
                    Value = $State -eq 'Enabled' ? '1' : '2'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Energy Saver - Always Use Energy Saver' to '$State' ..."
        Set-RegistryEntry -InputObject $EnergySaver
    }
}
