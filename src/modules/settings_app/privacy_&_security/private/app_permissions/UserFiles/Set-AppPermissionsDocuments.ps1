#=================================================================================================================
#                                Privacy & Security > App Permissions > Documents
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsDocuments
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AppPermissionsDocuments
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsDocuments -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: Allow (default) | off: Deny

        $Documents = [AppPermissionAccess]::new('documentsLibrary', $State)
        $Documents.WriteVerboseMsg('Documents')
        $Documents.SetRegistryEntry()
    }
}
