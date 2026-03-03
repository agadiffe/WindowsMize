#=================================================================================================================
#                                                Convert From Ini
#=================================================================================================================

<#
.SYNTAX
    ConvertFrom-Ini
        [-InputObject] <string>
        [<CommonParameters>]
#>

function ConvertFrom-Ini
{
    <#
    .DESCRIPTION
        Basic implementation tailored to Group Policy scripts needs.
        Comments are not handled.
        All values will be strings.

    .EXAMPLE
        PS> $IniContent = Get-Content -Raw -Path 'C:\MyScript.ps1'
        PS> $IniData = ConvertFrom-Ini -InputObject $IniContent
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [AllowEmptyString()]
        [string] $InputObject
    )

    process
    {
        $IniContent = [ordered]@{}
        switch -Regex ($InputObject -split "`r?`n")
        {
            '^\[(.+)\]'
            {
                $Section = $Matches[1]
                $IniContent[$Section] = [ordered]@{}
            }
            '(.+?)\s*=(.*)'
            {
                $Key, $Value = $Matches[1..2]
                $IniContent[$Section][$Key] = $Value
            }
        }
        $IniContent
    }
}
