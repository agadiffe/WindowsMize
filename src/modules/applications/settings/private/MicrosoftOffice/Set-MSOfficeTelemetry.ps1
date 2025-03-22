#=================================================================================================================
#                                    MSOffice - Options > Privacy > Telemetry
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeTelemetry
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MSOfficeTelemetry
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeTelemetry -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $IsEnabled = $State -eq 'Enabled'

        $MSOfficeTelemetry = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Policies\Microsoft\Office\Common\ClientTelemetry'
                Entries = @(
                    @{
                        Name  = 'SendTelemetry'
                        Value = $IsEnabled ? '1' : '3'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Policies\Microsoft\Office\16.0\Common'
                Entries = @(
                    @{
                        Name  = 'SendCustomerData'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'UpdateReliabilityData'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Policies\Microsoft\Office\16.0\Common\Privacy'
                Entries = @(
                    @{
                        Name  = 'DisconnectedState'
                        Value = $IsEnabled ? '1' : '2'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'DownloadContentDisabled'
                        Value = $IsEnabled ? '1' : '2'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'UserContentDisabled'
                        Value = $IsEnabled ? '1' : '2'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\Common'
                Entries = @(
                    @{
                        Name  = 'SendCustomerData'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'SendCustomerDataOptIn'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'SendCustomerDataOptInReason'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\Common\ClientTelemetry'
                Entries = @(
                    @{
                        Name  = 'DisableTelemetry'
                        Value = $IsEnabled ? '0' : '1'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'VerboseLogging'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\Common\ClientTelemetry'
                Entries = @(
                    @{
                        Name  = 'DisableTelemetry'
                        Value = $IsEnabled ? '0' : '1'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'VerboseLogging'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'MSOffice - Telemetry' to '$State' ..."
        $MSOfficeTelemetry | Set-RegistryEntry
    }
}
