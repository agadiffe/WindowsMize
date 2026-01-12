#=================================================================================================================
#                                              Remove Symbolic Link
#=================================================================================================================

<#
.SYNTAX
    Remove-SymbolicLink
        [-Path] <string[]>
        [<CommonParameters>]
#>

function Remove-SymbolicLink
{
    <#
    .EXAMPLE
        PS> Remove-SymbolicLink -Path 'C:\SymbolicLink1', 'C:\SymbolicLink2'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string[]] $Path
    )

    process
    {
        Get-Item -Path $Path | Where-Object -Property 'LinkType' -EQ -Value 'SymbolicLink' | Remove-Item
    }
}
