#=================================================================================================================
#                                  MSOffice - Options > Copilot > Enable Copilot
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeCopilot
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MSOfficeCopilot
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeCopilot -State 'Disabled'
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
        $MSOfficeCopilot = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\Excel\Options'
                Entries = @(
                    @{
                        Name  = 'EnableCopilot'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\PowerPoint\Options'
                Entries = @(
                    @{
                        Name  = 'EnableCopilot'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\Word\Options'
                Entries = @(
                    @{
                        Name  = 'EnableCopilot'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'MSOffice - Copilot' to '$State' ..."
        $MSOfficeCopilot | Set-RegistryEntry
    }
}
