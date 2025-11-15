#=================================================================================================================
#                                 Privacy & Security > App Permissions > Passkeys
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsPasskeys
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AppPermissionsPasskeys
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsPasskeys -State 'Disabled'
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

        $Passkeys = [AppPermissionAccess]::new('passkeys', $State)
        $Passkeys.WriteVerboseMsg('Passkeys')
        $Passkeys.SetRegistryEntry()
    }
}
