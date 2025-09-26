#=================================================================================================================
#                                               Printing Over HTTP
#=================================================================================================================

<#
.SYNTAX
    Set-PrintingOverHttp
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-PrintingOverHttp
{
    <#
    .EXAMPLE
        PS> Set-PrintingOverHttp -GPO 'Disabled'
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
        #   turn off printing over HTTP
        # not configured: delete (default) | on: 1
        $PrintingOverHttpGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows NT\Printers'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableHTTPPrinting'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Printing Over HTTP (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $PrintingOverHttpGpo
    }
}
