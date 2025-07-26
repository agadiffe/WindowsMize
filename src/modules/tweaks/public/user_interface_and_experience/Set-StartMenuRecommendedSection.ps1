#=================================================================================================================
#                                        Start Menu - Recommended Section
#=================================================================================================================

# Only applies to Enterprise and Education SKUs.
# With the new Start Menu, the Recommended section can be disabled in the settings.

<#
.SYNTAX
    Set-StartMenuRecommendedSection
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-StartMenuRecommendedSection
{
    <#
    .EXAMPLE
        PS> Set-StartMenuRecommendedSection -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > start menu and taskbar
        #   remove recommended section from Start Menu (only applies to Enterprise and Education SKUs)
        # not configured: delete (default) | on: 1
        $StartMenuRecommendedSectionGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\Explorer'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'HideRecommendedSection'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start Menu - Recommended Section (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $StartMenuRecommendedSectionGpo
    }
}
