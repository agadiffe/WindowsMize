#=================================================================================================================
#                            Privacy & Security > Recall & Snapshots > Save Snapshots
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsRecallSnapshots
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-WinPermissionsRecallSnapshots
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsRecallSnapshots -GPO 'NotConfigured'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > windowsAI
        #   turn off saving snapshots for Windows
        # not configured: delete (default) | on: 1
        $WinPermissionsRecallSnapshotsGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\WindowsAI'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableAIDataAnalysis'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Permissions - Recall & Snapshots: Save Snapshots (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $WinPermissionsRecallSnapshotsGpo
    }
}
