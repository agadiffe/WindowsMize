#=================================================================================================================
#                                    Gaming > Xbox Mode > Confirmation Prompts
#=================================================================================================================

<#
.SYNTAX
    Set-XboxModeConfirmationPrompts
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-XboxModeConfirmationPrompts
{
    <#
    .EXAMPLE
        PS> Set-XboxModeConfirmationPrompts -State 'Disabled'
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
        $XboxModeConfirmationPrompts = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\GamingConfiguration\SystemDialogResults'
            Entries = @(
                @{
                    Name  = 'EnterGamingPostureConfirmation_NoReboot'
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'ExitGamingPostureConfirmation_Minimal'
                    Value = $Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Gaming - Xbox Mode: Confirmation Prompts' to '$State' ..."
        Set-RegistryEntry -InputObject $XboxModeConfirmationPrompts
    }
}
