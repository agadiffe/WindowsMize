#=================================================================================================================
#                                  Personnalization > Start > All (Apps Section)
#=================================================================================================================

<#
.SYNTAX
    Set-StartAllAppsSection
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-StartAllAppsSection
{
    <#
    .EXAMPLE
        PS> Set-StartAllAppsSection -State 'Enabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $AllAppsSectionMsg = 'Start - All Apps Section'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $AllAppsSection = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
                    Entries = @(
                        @{
                            Name  = 'ShowAllAppsSection'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$AllAppsSectionMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $AllAppsSection
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > start menu and taskbar
                #   remove All Programs list from the Start menu
                # not configured: delete (default) | on: remove and disable setting (1)
                $AllAppsSectionGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'NoStartMenuMorePrograms'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$AllAppsSectionMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $AllAppsSectionGpo
            }
        }
    }
}
