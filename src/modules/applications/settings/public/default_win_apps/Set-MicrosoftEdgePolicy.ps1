#=================================================================================================================
#                                              Microsoft Edge Policy
#=================================================================================================================

# Basic settings if you don't use Edge and didn't removed it.
# Prevent Edge to run all the time in the background.

<#
.SYNTAX
    Set-MicrosoftEdgePolicy
        [-Prelaunch {Disabled | Enabled | NotConfigured}]
        [-StartupBoost {Disabled | Enabled | NotConfigured}]
        [-BackgroundMode {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-MicrosoftEdgePolicy
{
    <#
    .EXAMPLE
        PS> Set-MicrosoftEdgePolicy -Prelaunch 'Disabled' -StartupBoost 'Disabled' -BackgroundMode 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [GpoState] $Prelaunch,

        [GpoState] $StartupBoost,

        [GpoState] $BackgroundMode
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'Prelaunch'
            {
                # gpo\ computer config > administrative tpl > windows components > microsoft edge
                #   allow Microsoft Edge to pre-launch at Windows startup, when the sytem idle, and each time Microsoft Edge is closed
                # not configured: delete (default) | on: allow pre-launching (1), prevent pre-launching (0)
                $MicrosoftEdgePrelaunch = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main'
                    Entries = @(
                        @{
                            RemoveEntry = $Prelaunch -eq 'NotConfigured'
                            Name  = 'AllowPrelaunch'
                            Value = $Prelaunch -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Microsoft Edge - Prelaunch (GPO)' to '$Prelaunch' ..."
                Set-RegistryEntry -InputObject $MicrosoftEdgePrelaunch
            }
            'StartupBoost'
            {
                # gpo\ computer config > microsoft edge > performance
                #   enable startup boost
                # not configured: delete (default) | on: 1 | off: 0
                $MicrosoftEdgeStartupBoost = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Edge'
                    Entries = @(
                        @{
                            RemoveEntry = $StartupBoost -eq 'NotConfigured'
                            Name  = 'StartupBoostEnabled'
                            Value = $StartupBoost -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Microsoft Edge - Startup Boost (GPO)' to '$StartupBoost' ..."
                Set-RegistryEntry -InputObject $MicrosoftEdgeStartupBoost
            }
            'BackgroundMode'
            {
                # gpo\ computer config > microsoft edge
                #   continue running background apps after Microsoft Edge closes
                # not configured: delete (default) | on: 1 | off: 0
                $MicrosoftEdgeBackgroundMode = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Edge'
                    Entries = @(
                        @{
                            RemoveEntry = $BackgroundMode -eq 'NotConfigured'
                            Name  = 'BackgroundModeEnabled'
                            Value = $BackgroundMode -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Microsoft Edge - Background Mode (GPO)' to '$BackgroundMode' ..."
                Set-RegistryEntry -InputObject $MicrosoftEdgeBackgroundMode
            }
        }
    }
}
