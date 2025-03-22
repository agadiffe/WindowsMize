#=================================================================================================================
#                                 Open With Dialog: Look for an app in the Store
#=================================================================================================================

# Remove the 'Look for an app in the Store' item in the 'Open With' dialog.
# This does not affect the 'Open with > Search the Microsoft Store' context menu item.

<#
.SYNTAX
    Set-OpenWithDialogStoreAccess
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-OpenWithDialogStoreAccess
{
    <#
    .EXAMPLE
        PS> Set-OpenWithDialogStoreAccess -GPO 'Disabled'
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
        #   turn off access to the Store
        # not configured: delete (default) | on: 1
        $OpenWithDialogStoreAccessGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\Explorer'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'NoUseStoreOpenWith'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Open With Dialog: Look for an app in the Store (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $OpenWithDialogStoreAccessGpo
    }
}
