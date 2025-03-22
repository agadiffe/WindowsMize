#=================================================================================================================
#                     Windows Update > Delivery Optimization > Allow Downloads From Other PCs
#=================================================================================================================

<#
.SYNTAX
    Set-WinUpdateDeliveryOptimization
        [[-State] {Disabled | LocalNetwork | InternetAndLocalNetwork}]
        [-GPO {Disabled | LocalNetwork | InternetAndLocalNetwork | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinUpdateDeliveryOptimization
{
    <#
    .EXAMPLE
        PS> Set-WinUpdateDeliveryOptimization -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [DeliveryOptimizationMode] $State,

        [GpoDeliveryOptimizationMode] $GPO
    )

    process
    {
        $WinUpdateDeliveryOptimizationMsg = 'Windows Update - Delivery Optimization: Allow Downloads From Other PCs'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # off: 0 | devices on my local network: 1 (default) | devices on the internet and my local network: 3
                $WinUpdateDeliveryOptimization = @{
                    Hive    = 'HKEY_USERS'
                    Path    = 'S-1-5-20\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings'
                    Entries = @(
                        @{
                            Name  = 'DownloadMode'
                            Value = [int]$State
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinUpdateDeliveryOptimizationMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinUpdateDeliveryOptimization
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > delivery optimization
                #   download mode
                # not configured: delete (default) |  off: 0
                # devices on my local network: 1 | devices on the internet and my local network: 3
                $WinUpdateDeliveryOptimizationGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DODownloadMode'
                            Value = [int]$GPO
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinUpdateDeliveryOptimizationMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinUpdateDeliveryOptimizationGpo
            }
        }
    }
}
