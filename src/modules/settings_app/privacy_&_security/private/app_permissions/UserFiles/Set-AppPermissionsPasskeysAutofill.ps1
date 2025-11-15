#=================================================================================================================
#                            Privacy & Security > App Permissions > Passkeys Autofill
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsPasskeysAutofill
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AppPermissionsPasskeysAutofill
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsPasskeysAutofill -State 'Disabled'
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

        $PasskeysAutofill = [AppPermissionAccess]::new('passkeysEnumeration', $State)
        $PasskeysAutofill.WriteVerboseMsg('Passkeys Autofill')
        $PasskeysAutofill.SetRegistryEntry()
    }
}
