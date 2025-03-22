#=================================================================================================================
#                                     Helper Function - Get Hashtable Subset
#=================================================================================================================

<#
.SYNTAX
    Get-HashtableSubset
        [-Source] <Hashtable>
        [-DesiredKeys] <String[]>
        [[-SubStringToRemove] <String>]
        [<CommonParameters>]
#>

function Get-HashtableSubset
{
    <#
    .EXAMPLE
        PS> $HashtableSubsetParam = @{
                Source            = $PSBoundParameters
                DesiredKeys       = 'ThreeFingersUp', 'ThreeFingersDown', 'ThreeFingersLeft', 'ThreeFingersRight'
                SubStringToRemove = 'ThreeFingers'
            }
        PS> $ThreeFingersParam = Get-HashtableSubset @HashtableSubsetParam
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [hashtable] $Source,

        [Parameter(Mandatory)]
        [string[]] $DesiredKeys,

        [string] $SubStringToRemove
    )

    process
    {
        $FilteredHashtable  = @{}
        $Source.GetEnumerator() |
            Where-Object -FilterScript { $DesiredKeys -contains $_.Key } |
            ForEach-Object -Process { $FilteredHashtable.$($_.Key.replace($SubStringToRemove, '')) = $_.Value }

        $FilteredHashtable
    }
}
