#=================================================================================================================
#                                Personnalization > Colors > Transparency Effects
#=================================================================================================================

<#
.SYNTAX
    Set-ColorsTransparency
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ColorsTransparency
{
    <#
    .EXAMPLE
        PS> Set-ColorsTransparency -State 'Enabled'
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
        $ColorsTransparency = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
            Entries = @(
                @{
                    Name  = 'EnableTransparency'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Colors - Transparency Effects' to '$State' ..."
        Set-RegistryEntry -InputObject $ColorsTransparency
    }
}
