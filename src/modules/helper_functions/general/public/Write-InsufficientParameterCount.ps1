#=================================================================================================================
#                              Helper Function - Write Insufficient Parameter Count
#=================================================================================================================

<#
.SYNTAX
    Write-InsufficientParameterCount [<CommonParameters>]
#>

function Write-InsufficientParameterCount
{
    [CmdletBinding()]
    param ()

    process
    {
        'Insufficient number of parameters were provided.'
    }
}
