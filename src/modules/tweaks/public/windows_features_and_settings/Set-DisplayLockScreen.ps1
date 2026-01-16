#=================================================================================================================
#                                               Display Lock Screen
#=================================================================================================================

<#
.SYNTAX
    Set-DisplayLockScreen
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-DisplayLockScreen
{
    <#
    .EXAMPLE
        PS> Set-DisplayLockScreen -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > control panel > personalization
        #   do not display the lock screen
        # not configured: delete (default) | on: 1
        $LockScreenGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\Personalization'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'NoLockScreen'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Display Lock Screen (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $LockScreenGpo
    }
}
