#=================================================================================================================
#                             Time & Language > Date & Time > Set Time Automatically
#=================================================================================================================

<#
.SYNTAX
    Set-TimeAutomatically
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TimeAutomatically
{
    <#
    .EXAMPLE
        PS> Set-TimeAutomatically -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $IsEnabled = $State -eq 'Enabled'

        # on: NTP 3 (default) | off: NoSync 4
        $DateAndTimeAutoTime = @(
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SYSTEM\CurrentControlSet\Services\W32Time\Parameters'
                Entries = @(
                    @{
                        Name  = 'Type'
                        Value = $IsEnabled ? 'NTP' : 'NoSync'
                        Type  = 'String'
                    }
                )
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SYSTEM\CurrentControlSet\Services\W32Time'
                Entries = @(
                    @{
                        Name  = 'Start'
                        Value = $IsEnabled ? '3' : '4'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Date & Time - Set Time Automatically' to '$State' ..."
        $DateAndTimeAutoTime | Set-RegistryEntry
    }
}
