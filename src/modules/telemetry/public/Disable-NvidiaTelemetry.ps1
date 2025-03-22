#=================================================================================================================
#                                               Telemetry - NVidia
#=================================================================================================================

function Disable-NvidiaTelemetry
{
    # 'OptInOrOutPreference' and 'EnableRIDXXXXX' no longer needed (outdated) ?
    $NvidiaTelemetry = @(
        @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\SendTelemetryData'
            Entries = @(
                @{
                    Name  = '(Default)'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }
        @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup\SendNonNvDisplayDetails'
            Entries = @(
                @{
                    Name  = '(Default)'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }
        @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client'
            Entries = @(
                @{
                    Name  = 'OptInOrOutPreference'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }
        @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\NVIDIA Corporation\Global\FTS'
            Entries = @(
                @{
                    Name  = 'EnableRID44231'
                    Value = '0'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'EnableRID64640'
                    Value = '0'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'EnableRID66610'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }
    )

    Write-Verbose -Message "Disabling 'NVidia Telemetry' ..."
    $NvidiaTelemetry | Set-RegistryEntry

    Disable-NvidiaGameSessionTelemetry
}
