#=================================================================================================================
#                Windows Update > Advanced Options > Receive Updates For Other Microsoft Products
#=================================================================================================================

<#
.SYNTAX
    Set-WinUpdateOtherMicrosoftProducts
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
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

        [GpoState] $GPO
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
                $RegPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
                $AutoUpdateRegItemProperty = Get-ItemProperty -Path $RegPath -ErrorAction 'SilentlyContinue'
                $CurrentAutoUpdatePolicy = @{
                    AUOptions    = $AutoUpdateRegItemProperty.AUOptions
                    NoAutoUpdate = $AutoUpdateRegItemProperty.NoAutoUpdate
                }

                Write-Verbose -Message "Setting '$WinUpdateOtherMicrosoftProductsMsg (GPO)' to '$GPO' ..."

                if ($CurrentAutoUpdatePolicy['NoAutoUpdate'] -eq 1)
                {
                    Write-Verbose -Message "    GPO setting is already set to: 'Automatic update: Disabled'. Setting not applied."
                }
                else
                {
                    $IsNotConfigured = $GPO -eq 'NotConfigured'

                    # gpo\ computer config > administrative tpl > windows components > windows update > manage end user experience
                    #   configure automatic update
                    # not configured: delete (default) | on (Other Microsoft Products): 1 5 0 | off: delete delete 1
                    #
                    # configure automatic updating (AUOptions)\ Needed for this setting to be visible in the Group Policy Editor.
                    #   Notify for download and auto install:   2
                    #   Auto download and notify for install:   3
                    #   Auto download and schedule the install: 4
                    #   Allow local admin to choose setting:    5
                    #     -> This option (5) isn't available for Windows 10 or later versions.
                    #        Not really important for this function as we only want to control "updates for other Microsoft products".
                    # Install updates for other Microsoft products (AllowMUUpdateService)\
                    #   on: 1 | off: 0 (enforcement for 'off' has no GUI available via the Group Policy Editor)
                    # Automatic Updates (NoAutoUpdate)\ (only entry if the GPO is set to "Disabled")
                    #   on: 0 | off: 1
                    $WinUpdateOtherMicrosoftProductsGpo = @(
                        @{
                            Hive    = 'HKEY_LOCAL_MACHINE'
                            Path    = 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
                            Entries = @(
                                @{
                                    RemoveEntry = $IsNotConfigured
                                    Name  = 'AllowMUUpdateService'
                                    Value = $GPO -eq 'Enabled' ? '1' : '0'
                                    Type  = 'DWord'
                                }
                            )
                        }
                        @{
                            SkipKey = $IsNotConfigured -and $CurrentAutoUpdatePolicy['AUOptions'] -ne 5
                            Hive    = 'HKEY_LOCAL_MACHINE'
                            Path    = 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
                            Entries = @(
                                @{
                                    RemoveEntry = $IsNotConfigured
                                    Name  = 'AUOptions'
                                    Value = $CurrentAutoUpdatePolicy['AUOptions'] ? $CurrentAutoUpdatePolicy['AUOptions'] : '5'
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
                    )

                    $WinUpdateOtherMicrosoftProductsGpo | Set-RegistryEntry
                }
            }
        }
    }
}
