#=================================================================================================================
#                                                 Merge Hashtable
#=================================================================================================================

<#
.SYNTAX
    Merge-Hashtable
        [-Hashtable] <hashtable>
        [-Data] <hashtable>
        [-OverrideValue]
        [<CommonParameters>]
#>

function Merge-Hashtable
{
    <#
    .EXAMPLE
        PS> $foo = '{
                "data": {
                    "name": "answer"
                }
            }' | ConvertFrom-Json -AsHashtable
        PS> $bar = '{
                "data": {
                    "value": 42
                }
            }' | ConvertFrom-Json -AsHashtable
        PS> Merge-Hashtable -Hashtable $foo -Data $bar
        PS> $foo | ConvertTo-Json
        {
          "data": {
            "name": "answer",
            "value": 42
          }
        }
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [hashtable] $Hashtable,

        [Parameter(Mandatory)]
        [hashtable] $Data,

        [switch] $OverrideValue
    )

    process
    {
        foreach ($Key in $Data.Keys)
        {
            if ($Hashtable.$Key -is [hashtable] -and $Data.$Key -is [hashtable])
            {
                Merge-Hashtable -Hashtable $Hashtable.$Key -Data $Data.$Key -OverrideValue:$OverrideValue
            }
            else
            {
                $Hashtable.$Key = $OverrideValue ? $Data.$Key : $Hashtable.$Key + $Data.$Key
            }
        }
    }
}
