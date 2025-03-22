#=================================================================================================================
#              Defender > App & Browser Control > Reputation-Based Protection > Phishing Protection
#=================================================================================================================

# If you both configure the Group Policy to 'Disabled' and disable the related services (webthreatdefsvc):
# The message 'This setting is managed by your administrator.' will not appears and the setting will not be grayed out.

<#
.SYNTAX
    Set-DefenderPhishingProtection
        [-GPO] {Disabled | Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-DefenderPhishingProtection
{
    <#
    .EXAMPLE
        PS> Set-DefenderPhishingProtection -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoState] $GPO
    )

    process
    {
        $DefenderPhishingProtectionMsg = 'Defender - Phishing Protection'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # not used.

                # Requested registry access is not allowed.

                # on: 1 (default) | off: 0
                $DefenderPhishingProtection = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\WTDS\Components'
                    Entries = @(
                        @{
                            Name  = 'ServiceEnabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$DefenderPhishingProtectionMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $DefenderPhishingProtection
            }
            'GPO'
            {
                $IsNotConfigured = $GPO -eq 'NotConfigured'
                $GpoValue = $GPO -eq 'Enabled' ? '1' : '0'

                # gpo\ computer config > administrative tpl > windows components > windows defender smartscreen > enhanced phishing protection
                #   automatic data collection
                #   notify malicious
                #   notify passwords reuse
                #   notify unsafe app
                #   service enabled
                # not configured: delete (default) | on: 1 | off: 0
                $DefenderPhishingProtectionGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\System'
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'CaptureThreatWindow'
                            Value = $GpoValue
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'NotifyMalicious'
                            Value = $GpoValue
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'NotifyPasswordReuse'
                            Value = $GpoValue
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'NotifyUnsafeApp'
                            Value = $GpoValue
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'ServiceEnabled'
                            Value = $GpoValue
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$DefenderPhishingProtectionMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $DefenderPhishingProtectionGpo
            }
        }
    }
}
