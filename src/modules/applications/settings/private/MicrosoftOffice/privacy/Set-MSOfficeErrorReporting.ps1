#=================================================================================================================
#                                      MSOffice - Privacy > Error Reporting
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeErrorReporting
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeErrorReporting
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeErrorReporting -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ user config > administrative tpl > microsoft office > improve error reporting
        #   stop reporting error messages
        # not configured: delete (default) | on: 1
        #
        # gpo\ user config > administrative tpl > microsoft office > improve error reporting
        #   stop reporting non-critical errors
        # not configured: delete (default) | on: 1
        $MSOfficeErrorReportingGpo = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Policies\Microsoft\Office\16.0\Common\Alerts'
                Entries = @(
                    @{
                        RemoveEntry = $GPO -eq 'NotConfigured'
                        Name  = 'NoAlertReporting'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Policies\Microsoft\Office\16.0\Common\ShipAsserts'
                Entries = @(
                    @{
                        RemoveEntry = $GPO -eq 'NotConfigured'
                        Name  = 'DisableShipAsserts'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'MSOffice - Error Reporting (GPO)' to '$GPO' ..."
        $MSOfficeErrorReportingGpo | Set-RegistryEntry
    }
}
