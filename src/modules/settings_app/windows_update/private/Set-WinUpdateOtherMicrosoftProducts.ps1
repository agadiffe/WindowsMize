#=================================================================================================================
#                Windows Update > Advanced Options > Receive Updates For Other Microsoft Products
#=================================================================================================================

# The Group Policy Editor GUI add more entries than the two below.
# We can't enable only this setting with Group Policy Editor GUI, we need to do it manually.

<#
.SYNTAX
    Set-WinUpdateOtherMicrosoftProducts
        [[-State] {Disabled | Enabled}]
        [-GPO {Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinUpdateOtherMicrosoftProducts
{
    <#
    .EXAMPLE
        PS> Set-WinUpdateOtherMicrosoftProducts -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoStateWithoutDisabled] $GPO
    )

    process
    {
        $WinUpdateOtherMicrosoftProductsMsg = 'Windows Update - Receive Updates For Other Microsoft Products'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # Ensure that the "Microsoft Update" service is registered (as it is on default install).
                # Related registry entries:
                #   [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services]
                #   "DefaultService"="7971f918-a847-4430-9279-4a52d1efe18d"
                #   [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Services\7971f918-a847-4430-9279-4a52d1efe18d]
                #   "RegisteredWithAU"=dword:00000001
                $ServiceManager = New-Object -ComObject 'Microsoft.Update.ServiceManager'
                $ServiceId = '7971f918-a847-4430-9279-4a52d1efe18d'
                $ServiceManager.AddService2($ServiceId, 7, '') | Out-Null

                # on: 1 (default) | off: 0
                $WinUpdateOtherMicrosoftProducts = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'
                    Entries = @(
                        @{
                            Name  = 'AllowMUUpdateService'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinUpdateOtherMicrosoftProductsMsg' to '$State' ..."
                Write-Verbose -Message "  Register 'Microsoft.Update.ServiceManager': 'Microsoft Update ($ServiceId)' service"
                Set-RegistryEntry -InputObject $WinUpdateOtherMicrosoftProducts
            }
            'GPO'
            {
                $IsNotConfigured = $GPO -eq 'NotConfigured'

                # gpo\ computer config > administrative tpl > windows components > windows update > manage end user experience
                #   configure automatic update
                # not configured: delete (default) | on (Other Microsoft Products): 1 0
                $WinUpdateOtherMicrosoftProductsGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'AllowMUUpdateService'
                            Value = '1'
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'NoAutoUpdate'
                            Value = '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinUpdateOtherMicrosoftProductsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinUpdateOtherMicrosoftProductsGpo
            }
        }
    }
}
