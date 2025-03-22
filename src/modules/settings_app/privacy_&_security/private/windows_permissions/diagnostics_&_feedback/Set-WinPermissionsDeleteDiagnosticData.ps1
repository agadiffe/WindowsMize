#=================================================================================================================
#                       Privacy & Security > Diagnostics & Feedback > Delete Diagnostic Data
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsDeleteDiagnosticData
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-WinPermissionsDeleteDiagnosticData
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsDeleteDiagnosticData -GPO 'NotConfigured'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > data collection and preview builds
        #   disable deleting diagnostic data
        # not configured: delete (default) | on: 1
        $WinPermissionsDeleteDiagnosticDataGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\DataCollection'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableDeviceDelete'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Permissions - Diagnostics & Feedback: Delete Diagnostic Data (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $WinPermissionsDeleteDiagnosticDataGpo
    }
}
