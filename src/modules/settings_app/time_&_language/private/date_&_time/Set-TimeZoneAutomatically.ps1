#=================================================================================================================
#                           Time & Language > Date & Time > Set Time Zone Automatically
#=================================================================================================================

# Already disabled if location permission is off.

<#
.SYNTAX
    Set-TimeZoneAutomatically
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TimeZoneAutomatically
{
    <#
    .EXAMPLE
        PS> Set-TimeZoneAutomatically -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 3 (default) | off: 4
        $DateAndTimeAutoTimeZone = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Services\tzautoupdate'
            Entries = @(
                @{
                    Name  = 'Start'
                    Value = $State -eq 'Enabled' ? '3' : '4'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Date & Time - Set Time Zone Automatically' to '$State' ..."
        Set-RegistryEntry -InputObject $DateAndTimeAutoTimeZone
    }
}
