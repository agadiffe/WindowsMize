#=================================================================================================================
#                     MSOffice - Options > Privacy > Customer Experience Improvement Program
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeCeip
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MSOfficeCeip
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeCeip -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $Value = $State -eq 'Enabled' ? '1' : '0'

        # on: 1 (default) | off: 0
        $MSOfficeCeip = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Policies\Microsoft\Office\16.0\Common'
                Entries = @(
                    @{
                        Name  = 'QMEnable'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\Common'
                Entries = @(
                    @{
                        Name  = 'QMEnable'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'MSOffice - Customer Experience Improvement Program (CEIP)' to '$State' ..."
        $MSOfficeCeip | Set-RegistryEntry
    }
}
