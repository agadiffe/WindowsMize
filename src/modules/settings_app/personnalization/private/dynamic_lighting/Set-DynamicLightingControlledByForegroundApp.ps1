#=================================================================================================================
#         Personnalization > Dynamic Lighting > Compatible Apps In The Foreground Always Control Lighting
#=================================================================================================================

<#
.SYNTAX
    Set-DynamicLightingControlledByForegroundApp
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DynamicLightingControlledByForegroundApp
{
    <#
    .EXAMPLE
        PS> Set-DynamicLightingControlledByForegroundApp -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $DynamicLightingControlledByForegroundApp = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Lighting'
            Entries = @(
                @{
                    Name  = 'ControlledByForegroundApp'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Dynamic Lighting - Compatible Apps In The Foreground Always Control Lighting' to '$State' ..."
        Set-RegistryEntry -InputObject $DynamicLightingControlledByForegroundApp
    }
}
