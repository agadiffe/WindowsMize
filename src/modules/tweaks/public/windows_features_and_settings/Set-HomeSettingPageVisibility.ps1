#=================================================================================================================
#                                          Home Setting Page Visibility
#=================================================================================================================

<#
.SYNTAX
    Set-HomeSettingPageVisibility
        [-GPO] {Hide | Show}
        [<CommonParameters>]
#>

function Set-HomeSettingPageVisibility
{
    <#
    .DESCRIPTION
        Control only the visibility of the Home page. Other GPO PageID values are not modified.

    .EXAMPLE
        PS> Set-HomeSettingPageVisibility -GPO 'Hide'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Hide', 'Show')]
        [string] $GPO
    )

    process
    {
        $GpoData = Get-SettingsPageVisibilityData
        $Mode = $GpoData['Mode'] -eq 'ShowOnly' ? 'ShowOnly' : 'Hide'
        $Action = $Mode.Substring(0, 4) -eq $GPO ? 'Add' : 'Remove'

        Set-SettingsPageVisibility -PageId 'home' -Mode $Mode -Action $Action
    }
}
