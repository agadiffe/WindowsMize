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
        $UserSid = (Get-LoggedOnUserInfo).Sid
        $ItemRegPath = "Registry::HKEY_USERS\$UserSid\$Path"
        $ItemValue = (Get-ItemProperty -Path $ItemRegPath -ErrorAction 'SilentlyContinue').$Name
        $ItemValue
    }
}
