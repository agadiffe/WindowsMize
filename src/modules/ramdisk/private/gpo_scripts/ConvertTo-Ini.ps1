#=================================================================================================================
#                                                 Convert To Ini
#=================================================================================================================

<#
.SYNTAX
    ConvertTo-Ini
        [-InputObject] <string>
        [<CommonParameters>]
#>

function ConvertTo-Ini
{
    <#
    .DESCRIPTION
        Basic implementation tailored to Group Policy scripts needs.
        Comments are not handled.

    .EXAMPLE
        PS> $IniData = [ordered]@{
                Section1 = [ordered]@{
                    Key1 = 'Value1'
                    Key2 = 'Value2'
                }
                Section2 = [ordered]@{
                    Key1 = 'Value1'
                    Key2 = 'Value2'
                }
            }
        PS> $IniContent = ConvertTo-Ini -InputObject $IniData
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Collections.IDictionary] $InputObject
    )

    process
    {
        foreach ($Section in $InputObject.Keys)
        {
            "[$Section]"
            foreach ($Key in $InputObject[$Section].Keys)
            {
                "$Key=$($InputObject[$Section][$Key])"
            }
            ""
        }
    }
}
