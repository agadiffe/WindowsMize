#=================================================================================================================
#                                                 Write Function
#=================================================================================================================

<#
.SYNTAX
    Write-Function
        [-Name] <string>
        [<CommonParameters>]
#>

function Write-Function
{
    <#
    .EXAMPLE
        PS> Write-Function -Name 'MyFunction'
        function MyFunction
        {
            # function definition
        }
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Name
    )

    process
    {
        "function $Name`n{$((Get-Command -Name $Name -ErrorAction 'SilentlyContinue').Definition)}"
    }
}
