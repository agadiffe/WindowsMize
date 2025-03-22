#=================================================================================================================
#                                                 Write Function
#=================================================================================================================

function Write-Function
{
    <#
    .SYNTAX
        Write-Function
            [-Name] <string>
            [<CommonParameters>]

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
        "function $Name"
        "{$((Get-Command -Name $Name -ErrorAction 'SilentlyContinue').Definition)}"
        ''
    }
}
