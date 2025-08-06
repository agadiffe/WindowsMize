#=================================================================================================================
#                                  System > Power & Battery > Battery Percentage
#=================================================================================================================

<#
.SYNTAX
    Set-PowerBatteryPercentage
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-PowerBatteryPercentage
{
    <#
    .EXAMPLE
        PS> Set-PowerBatteryPercentage -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $BatteryPercentage = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'IsBatteryPercentageEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '2'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Power - Battery Percentage' to '$State' ..."
        Set-RegistryEntry -InputObject $BatteryPercentage
    }
}
