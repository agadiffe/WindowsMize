#=================================================================================================================
#                                                 Test GPO Script
#=================================================================================================================

<#
.SYNTAX
    Test-GpoScript
        [-Name] <string>
        [-Type] {Logon | Logoff}
        [<CommonParameters>]
#>

function Test-GpoScript
{
    <#
    .DESCRIPTION
        Test if the Group Policy Script exist.

    .EXAMPLE
        PS> Test-GpoScript -Name 'C:\MyScript.ps1' -Type 'Logoff'
        False
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [ValidateSet('Logon', 'Logoff')]
        [string] $Type
    )

    process
    {
        $UserSid = (Get-LoggedOnUserInfo).Sid
        $GPOScriptRegPath = "HKEY_USERS\$UserSid\Software\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\$Type\0"
        $RegItems = Get-ChildItem -Path "Registry::$GPOScriptRegPath" -ErrorAction 'SilentlyContinue'

        $Result = $false
        foreach ($Item in $RegItems)
        {
            if ((Get-ItemPropertyValue -Path "Registry::$Item" -Name 'Script') -eq $Name)
            {
                $Result = $true
                break
            }
        }
        $Result
    }
}
