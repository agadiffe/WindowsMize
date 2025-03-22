#=================================================================================================================
#                                       Printer Drivers Download Over HTTP
#=================================================================================================================

<#
.SYNTAX
    Set-PrinterDriversDownloadOverHttp
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-PrinterDriversDownloadOverHttp
{
    <#
    .EXAMPLE
        PS> Set-PrinterDriversDownloadOverHttp -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > system > internet communication management > internet communication settings
        #   turn off downloading of print drivers over HTTP
        # not configured: delete (default) | on: 1
        $PrinterDriversDownloadOverHttpGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows NT\Printers'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableWebPnPDownload'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Printer Drivers Download Over HTTP (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $PrinterDriversDownloadOverHttpGpo
    }
}
