#=================================================================================================================
#                                             New Symbolic Links Pair
#=================================================================================================================

<#
.SYNTAX
    New-SymbolicLinksPair
        [-Data] <hashtable>
        [<CommonParameters>]
#>

function New-SymbolicLinksPair
{
    <#
    .EXAMPLE
        PS>
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [hashtable] $Data
    )

    process
    {
        $SymbolicLinksPair = foreach ($Value in $Data.Values)
        {
            foreach ($Key in $Value.Data.Keys)
            {
                foreach ($Name in $Value.Data[$Key])
                {
                    [PSCustomObject]@{
                        Path       = "$($Value.LinkPath)\$Name"
                        Target     = "$($Value.TargetPath)\$Name"
                        TargetType = $Key
                    }
                }
            }
        }
        $SymbolicLinksPair
    }
}
