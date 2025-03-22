#=================================================================================================================
#      Defender > App & Browser Control > Reputation-Based Protection > Smartscreen For Microsoft Store Apps
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderSmartScreenForStoreApps
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DefenderSmartScreenForStoreApps
{
    <#
    .EXAMPLE
        PS> Set-DefenderSmartScreenForStoreApps -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 0 (default) | off: 0 0
        $DefenderSmartScreenForStoreApps = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\AppHost'
            Entries = @(
                @{
                    Name  = 'EnableWebContentEvaluation'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'PreventOverride'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Defender - Smartscreen For Microsoft Store Apps' to '$State' ..."
        Set-RegistryEntry -InputObject $DefenderSmartScreenForStoreApps
    }
}
