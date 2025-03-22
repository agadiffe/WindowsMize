#=================================================================================================================
#                     Bluetooth & Devices > AutoPlay > Use AutoPlay For All Media And Devices
#=================================================================================================================

<#
.SYNTAX
    Set-AutoPlay
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AutoPlay
{
    <#
    .EXAMPLE
        PS> Set-AutoPlay -State 'Disabled' -GPO 'NotConfigured'
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
        $AutoPlayMsg = 'AutoPlay - Use AutoPlay For All Media And Devices'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 0 (default) | off: 1
                $AutoPlay = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers'
                    Entries = @(
                        @{
                            Name  = 'DisableAutoplay'
                            Value = $State -eq 'Enabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$AutoPlayMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $AutoPlay
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > autoPlay policies
                #   turn off autoplay
                # not configured: delete (default) | on: 255 (all drives), 181 (CD-ROM and removable media drives)
                #
                #   disallow autoplay for non-volume devices (MTP devices like cameras or phones)
                # not configured: delete (default) | on: 1
                $AutoPlayGpo = @(
                    @{
                        Hive    = 'HKEY_LOCAL_MACHINE'
                        Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
                        Entries = @(
                            @{
                                RemoveEntry = $GPO -eq 'NotConfigured'
                                Name  = 'NoDriveTypeAutoRun'
                                Value = '255'
                                Type  = 'DWord'
                            }
                        )
                    }
                    @{
                        Hive    = 'HKEY_LOCAL_MACHINE'
                        Path    = 'SOFTWARE\Policies\Microsoft\Windows\Explorer'
                        Entries = @(
                            @{
                                RemoveEntry = $GPO -eq 'NotConfigured'
                                Name  = 'NoAutoplayfornonVolume'
                                Value = '1'
                                Type  = 'DWord'
                            }
                        )
                    }
                )

                Write-Verbose -Message "Setting '$AutoPlayMsg (GPO)' to '$GPO' ..."
                $AutoPlayGpo | Set-RegistryEntry
            }
        }
    }
}
