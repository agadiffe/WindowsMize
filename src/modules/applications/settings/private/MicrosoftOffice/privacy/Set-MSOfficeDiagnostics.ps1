#=================================================================================================================
#                                        MSOffice - Privacy > Diagnostics
#=================================================================================================================

# This policy setting controls whether Microsoft Office Diagnostics is enabled.
# If not configured, users have the opportunity to opt into receiving updates from Office Diagnostics the first
# time they run an Office application.

<#
.SYNTAX
    Set-MSOfficeDiagnostics
        [-GPO] {Disabled | Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeDiagnostics
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeDiagnostics -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoState] $GPO
    )

    process
    {
        # gpo\ user config > administrative tpl > microsoft office > privacy > trust center
        #   automatically receive small updates to improve reliability
        # not configured: delete (default) | off: 0
        $MSOfficeDiagnosticsGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\Common'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'UpdateReliabilityData'
                    Value = $GPO -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - Diagnostics' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeDiagnosticsGpo
    }
}
