#=================================================================================================================
#                                 System > Clipboard > Sync Across Your Devices
#=================================================================================================================

<#
.SYNTAX
    Set-ClipboardSyncAcrossDevices
        [[-State] {Disabled | AutoSync | ManualSync}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-ClipboardSyncAcrossDevices
{
    <#
    .EXAMPLE
        PS> Set-ClipboardSyncAcrossDevices -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [ClipboardSyncState] $State,

        [GpoState] $GPO
    )

    process
    {
        $ClipboardSyncAcrossDevicesMsg = 'Clipboard - Sync Across Your Devices'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # EnableCloudClipboard\ on: 1 | off: 0 (default)
                # CloudClipboardAutomaticUpload\ automatically sync text I copy: 1 | manually sync text that I copy: 0
                $ClipboardSyncAcrossDevices = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Clipboard'
                    Entries = @(
                        @{
                            Name  = 'EnableCloudClipboard'
                            Value = $State -ne 'Disabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                        @{
                            Name  = 'CloudClipboardAutomaticUpload'
                            Value = $State -eq 'AutoSync' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ClipboardSyncAcrossDevicesMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $ClipboardSyncAcrossDevices
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > system > OS policies
                #   allow clipboard synchronization across devices
                # not configured: delete (default) | on: 1 | off: 0
                $ClipboardSyncAcrossDevicesGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\System'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'AllowCrossDeviceClipboard'
                            Value = $GPO -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ClipboardSyncAcrossDevicesMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $ClipboardSyncAcrossDevicesGpo
            }
        }
    }
}
