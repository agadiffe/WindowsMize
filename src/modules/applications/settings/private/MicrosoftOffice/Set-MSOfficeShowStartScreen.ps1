#=================================================================================================================
#                              MSOffice - Options > General > Show The Start Screen
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeStartScreen
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MSOfficeShowStartScreen
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeShowStartScreen -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $Value = $State -eq 'Enabled' ? '0' : '1'

        # on: 0 (default) | off: 1
        $MSOfficeShowStartScreen = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\excel\options'
                Entries = @(
                    @{
                        Name  = 'DisableBootToOfficeStart'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\powerpoint\options'
                Entries = @(
                    @{
                        Name  = 'DisableBootToOfficeStart'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\Word\options'
                Entries = @(
                    @{
                        Name  = 'DisableBootToOfficeStart'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'MSOffice - Show The Start Screen' to '$State' ..."
        $MSOfficeShowStartScreen | Set-RegistryEntry
    }
}
