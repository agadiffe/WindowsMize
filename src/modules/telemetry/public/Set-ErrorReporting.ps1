#=================================================================================================================
#                                           Telemetry - Error Reporting
#=================================================================================================================

<#
.SYNTAX
    Set-ErrorReporting
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-ErrorReporting
{
    <#
    .EXAMPLE
        PS> Set-ErrorReporting -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $IsNotConfigured = $GPO -eq 'NotConfigured'

        # gpo\ computer config > administrative tpl > windows components > Windows error reporting
        #   disable Windows error reporting
        #   do not send additional data
        # not configured: delete (default) | on: 1 1
        #
        # gpo\ computer config > administrative tpl > system > device installation (windows 10 only ?)
        #   do not send a Windows error report when a generic driver is installed on a device
        #   prevent Windows from sending an error report when a device driver requests additional software during installation
        # not configured: delete (default) | on: 1 1
        #
        # gpo\ computer config > administrative tpl > system > internet communication management > internet communication settings
        #   turn off Windows error reporting
        # not configured: delete (default) | on: 0
        $ErrorReportingGpo = @(
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'Disabled'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'DontSendAdditionalData'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'DisableSendGenericDriverNotFoundToWER'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'DisableSendRequestAdditionalSoftwareToWER'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'DoReport'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Error Reporting (GPO)' to '$GPO' ..."
        $ErrorReportingGpo | Set-RegistryEntry
    }
}
