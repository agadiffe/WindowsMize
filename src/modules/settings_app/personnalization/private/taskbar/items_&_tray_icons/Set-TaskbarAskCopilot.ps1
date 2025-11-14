#=================================================================================================================
#                            Personnalization > Taskbar > Taskbar Items > Ask Copilot
#=================================================================================================================

# UCPD filter driver prevent the modification of this registry key ?
# BrandedKeyChoiceType: Requested registry access is not allowed.

<#
.SYNTAX
    Set-TaskbarAskCopilot
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarAskCopilot
{
    <#
    .EXAMPLE
        PS> Set-TaskbarAskCopilot -State 'Disabled'
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

        # on: 1 TaskbarCompanion (default) | off: 0 NoneSelected
        $TaskbarAskCopilotButton = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                Entries = @(
                    @{
                        Name  = 'TaskbarCompanion'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\Shell\BrandedKey'
                Entries = @(
                    @{
                        Name  = 'BrandedKeyChoiceType'
                        Value = $IsEnabled ? 'TaskbarCompanion' : 'NoneSelected'
                        Type  = 'String'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Taskbar Items - Ask Copilot' to '$State' ..."
        $TaskbarAskCopilotButton | Set-RegistryEntry
    }
}
