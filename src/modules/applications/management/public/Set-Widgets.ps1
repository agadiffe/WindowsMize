#=================================================================================================================
#                                                     Widgets
#=================================================================================================================

# Not needed if you have uninstalled widgets.
# Disable it anyway in case widgets reinstall itself (it might happen).

<#
.SYNTAX
    Set-Widgets
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-Widgets
{
    <#
    .EXAMPLE
        PS> Set-Widgets -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components> widgets
        #   allow widgets
        # not configured: delete (default) | off: 0

        $WidgetsGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Dsh'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'AllowNewsAndInterests'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Widgets (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $WidgetsGpo
    }
}
