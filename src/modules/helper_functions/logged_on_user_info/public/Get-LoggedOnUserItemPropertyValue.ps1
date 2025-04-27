#=================================================================================================================
#                                    LoggedOn User Info - Item Property Value
#=================================================================================================================

<#
.SYNTAX
    Get-LoggedOnUserItemPropertyValue
        [-Path] <string>
        [-Name] <string>
        [<CommonParameters>]
#>

function Get-LoggedOnUserItemPropertyValue
{
    <#
    .EXAMPLE
        PS> Get-LoggedOnUserItemPropertyValue -Path 'Control Panel\Desktop' -Name 'UserPreferencesMask'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Name
    )

    process
    {
        $UserSID = Get-LoggedOnUserSID
        $ItemRegPath = "Registry::HKEY_USERS\$UserSID\$Path"
        $ItemValue = (Get-ItemProperty -Path $ItemRegPath -ErrorAction 'SilentlyContinue').$Name
        $ItemValue
    }
}
