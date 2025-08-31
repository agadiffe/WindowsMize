#=================================================================================================================
#                                         Windows Update > Pause Updates
#=================================================================================================================

<#
.SYNTAX
    Set-WinUpdatePauseUpdates
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-WinUpdatePauseUpdates
{
    <#
    .EXAMPLE
        PS> Set-WinUpdatePauseUpdates -GPO 'NotConfigured'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > windows update > manage end user experience
        #   remove access to 'pause updates' feature
        # not configured: delete (default) | on: 1
        $WinUpdatePauseUpdatesGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'SetDisablePauseUXAccess'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Update - Pause Updates (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $WinUpdatePauseUpdatesGpo
    }
}
