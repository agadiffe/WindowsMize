#=================================================================================================================
#                                             Get GPO Script Reg Path
#=================================================================================================================

<#
.SYNTAX
    Get-GpoScriptRegPath
        [-Type] {Logon | Logoff}
        [<CommonParameters>]
#>

function Get-GpoScriptRegPath
{
    <#
    .EXAMPLE
        PS> Get-GpoScriptRegPath -Type 'Logoff'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoScriptType] $Type
    )

    process
    {
        $UserSid = (Get-LoggedOnUserInfo).Sid
        $GpoScriptRegPath = "HKEY_USERS\$UserSid\Software\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\$Type\0"
        $GpoScriptRegPath
    }
}
