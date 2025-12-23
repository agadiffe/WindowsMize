#=================================================================================================================
#                                         System > Advanced > Run Dialog
#=================================================================================================================

<#
.SYNTAX
    Set-ModernRunDialog
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ModernRunDialog
{
    <#
    .EXAMPLE
        PS> Set-ModernRunDialog -State 'Enabled'
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
        $ModernRunDialog = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings'
            Entries = @(
                @{
                    Name  = 'Run'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'System Advanced - Modern Run Dialog' to '$State' ..."
        Set-RegistryEntry -InputObject $ModernRunDialog
    }
}
