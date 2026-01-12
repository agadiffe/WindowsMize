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
        [GpoScriptType] $Type
    )

    process
    {
        $GpoScriptRegPath = Get-GpoScriptRegPath -Type $Type
        $RegItems = Get-ChildItem -Path "Registry::$GpoScriptRegPath" -ErrorAction 'SilentlyContinue'

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
