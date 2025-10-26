#=================================================================================================================
#                                                     Cortana
#=================================================================================================================

# old

# Cortana has been deprecated and is no more installed by default.

<#
.SYNTAX
    Set-Cortana
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-Cortana
{
    <#
    .EXAMPLE
        PS> Set-Cortana -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > search
        #   allow cortana
        #   allow cortana above lock screen
        # not configured: delete (default) | off: 0

        $IsNotConfigured = $GPO -eq 'NotConfigured'

        $CortanaGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\Windows Search'
            Entries = @(
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'AllowCortana'
                    Value = '0'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'AllowCortanaAboveLock'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Cortana (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $CortanaGpo
    }
}
