#=================================================================================================================
#                                 Privacy & Security > App Permissions > Calendar
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsCalendar
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsCalendar
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsCalendar -State 'Disabled' -GPO 'NotConfigured'
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
        $CalendarMsg = 'Calendar'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $Calendar = [AppPermissionAccess]::new('appointments', $State)
                $Calendar.WriteVerboseMsg($CalendarMsg)
                $Calendar.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access the calendar
                # not configured: delete (default) | on: 1 | off: 2

                $CalendarGpo = [AppPermissionPolicy]::new('LetAppsAccessCalendar', $GPO)
                $CalendarGpo.WriteVerboseMsg("$CalendarMsg (GPO)")
                $CalendarGpo.SetRegistryEntry()
            }
        }
    }
}
