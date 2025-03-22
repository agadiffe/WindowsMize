#=================================================================================================================
#                  Defender > Virus & Threat Protection > Settings > Cloud-Delivered Protection
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderCloudDeliveredProtection
        [[-State] {Disabled | Basic | Advanced}]
        [-GPO {Disabled | Basic | Advanced | NotConfigured}]
        [<CommonParameters>]
#>

function Set-DefenderCloudDeliveredProtection
{
    <#
    .EXAMPLE
        PS> Set-DefenderCloudDeliveredProtection -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [CloudDelivereMode] $State,

        [GpoCloudDelivereMode] $GPO
    )

    process
    {
        $DefenderCloudDeliveredMsg = 'Defender - Cloud-Delivered Protection'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # Disabled | Basic | Advanced (default)
                Write-Verbose -Message "Setting '$DefenderCloudDeliveredMsg' to '$State' ..."
                Set-MpPreference -MAPSReporting $State
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > microsoft defender antivirus > MAPS
                #   join Microsoft MAPS
                # not configured: delete (default) | basic: 1 | advanced: 2 | off: 0
                $DefenderCloudDeliveredGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows Defender\Spynet'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'SpynetReporting'
                            Value = [int]$GPO
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$DefenderCloudDeliveredMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $DefenderCloudDeliveredGpo
            }
        }
    }
}
