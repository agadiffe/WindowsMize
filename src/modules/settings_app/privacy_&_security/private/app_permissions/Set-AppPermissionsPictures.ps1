#=================================================================================================================
#                                 Privacy & Security > App Permissions > Pictures
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsPictures
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AppPermissionsPictures
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsPictures -State 'Disabled'
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

        $Pictures = [AppPermissionAccess]::new('picturesLibrary', $State)
        $Pictures.WriteVerboseMsg('Pictures')
        $Pictures.SetRegistryEntry()
    }
}
