#=================================================================================================================
#                           Telemetry - Customer Experience Improvement Program (CEIP)
#=================================================================================================================

# Turning off Customer Experience Improvement Program will prevent potentially
# sensitive information from being sent to the vendor (e.g. Microsoft or others).

# STIG recommendation: Disabled

<#
.SYNTAX
    Set-Ceip
        [-GPO] {Disabled | Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-Ceip
{
    <#
    .EXAMPLE
        PS> Set-Ceip -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoState] $GPO
    )

    process
    {
        $IsNotConfigured = $GPO -eq 'NotConfigured'
        $CeipMessenger, $Ceip, $CeipAppV = switch ($GPO)
        {
            'Enabled'  { '1', '1', '1' }
            'Disabled' { '2', '0', '0' }
        }

        # gpo\ computer config > administrative tpl > system > internet communication management > internet communication settings
        #   turn off the Windows Messenger customer experience improvement program
        #   turn off Windows customer experience improvement program
        # not configured: delete (default) | off: 1 1 | on: 2 0
        #
        # gpo\ computer config > administrative tpl > system > appv > ceip
        #   Microsoft customer experience improvement program (CEIP)
        # not configured: delete (default) | off: 0 | on: 1
        $CeipGpo = @(
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Microsoft\Messenger\Client'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'CEIP'
                        Value = $CeipMessenger
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Microsoft\SQMClient\Windows'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'CEIPEnable'
                        Value = $Ceip
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Microsoft\AppV\CEIP'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'CEIPEnable'
                        Value = $CeipAppV
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Customer Experience Improvement Program (CEIP) (GPO)' to '$GPO' ..."
        $CeipGpo | Set-RegistryEntry
    }
}
