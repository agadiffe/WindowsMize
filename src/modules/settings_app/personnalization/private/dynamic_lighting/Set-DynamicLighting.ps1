#=================================================================================================================
#                     Personnalization > Dynamic Lighting > Use Dynamic Lighting On My Device
#=================================================================================================================

<#
.SYNTAX
    Set-DynamicLighting
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DynamicLighting
{
    <#
    .EXAMPLE
        PS> Set-DynamicLighting -State 'Disabled'
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
        $DynamicLighting = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Lighting'
            Entries = @(
                @{
                    Name  = 'AmbientLightingEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Dynamic Lighting - Use Dynamic Lighting On My Device' to '$State' ..."
        Set-RegistryEntry -InputObject $DynamicLighting
    }
}
