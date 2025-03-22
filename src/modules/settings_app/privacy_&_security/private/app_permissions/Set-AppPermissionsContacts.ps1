#=================================================================================================================
#                                 Privacy & Security > App Permissions > Contacts
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsContacts
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsContacts
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsContacts -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoState] $GPO
    )

    process
    {
        $ContactsMsg = 'Contacts'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $Contacts = [AppPermissionAccess]::new('contacts', $State)
                $Contacts.WriteVerboseMsg($ContactsMsg)
                $Contacts.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access contacts
                # not configured: delete (default) | on: 1 | off: 2

                $ContactsGpo = [AppPermissionPolicy]::new('LetAppsAccessContacts', $GPO)
                $ContactsGpo.WriteVerboseMsg("$ContactsMsg (GPO)")
                $ContactsGpo.SetRegistryEntry()
            }
        }
    }
}
