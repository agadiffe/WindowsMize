#=================================================================================================================
#                                            Lock Screen Camera Access
#=================================================================================================================

# Enabling camera access from the lock screen could allow for unauthorized use.

# STIG recommendation: Disabled

<#
.SYNTAX
    Set-LockScreenCameraAccess
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-LockScreenCameraAccess
{
    <#
    .EXAMPLE
        PS> Set-LockScreenCameraAccess -GPO 'Disabled'
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
        #   prevent enabling lock screen camera
        # not configured: delete (default) | on: 1
        $LockScreenCameraAccessGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\Personalization'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'NoLockScreenCamera'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Lock Screen Camera Access (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $LockScreenCameraAccessGpo
    }
}
