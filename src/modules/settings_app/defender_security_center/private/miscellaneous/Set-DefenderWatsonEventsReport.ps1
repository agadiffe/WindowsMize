#=================================================================================================================
#                                 Defender > Miscellaneous > Watson Events Report
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderWatsonEventsReport
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-DefenderWatsonEventsReport
{
    <#
    .EXAMPLE
        PS> Set-DefenderWatsonEventsReport -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > microsoft defender antivirus > reporting
        #   configure Watson events
        # not configured: delete (default) | off: 1
        $DefenderWatsonEventsReportGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows Defender\Reporting'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableGenericRePorts'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Defender - Watson Events Report (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $DefenderWatsonEventsReportGpo
    }
}
