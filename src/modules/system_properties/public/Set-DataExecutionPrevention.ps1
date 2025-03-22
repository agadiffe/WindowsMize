#=================================================================================================================
#                     System Properties - Advanced > Performance > Data Execution Prevention
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

# turn on DEP for essential Windows programs and services only (OptIn)
# turn on DEP for all programs and services except those I select (OptOut)

# Data Execution Prevention (DEP) helps protects against damage from viruses and other security threats.

# default: OptIn
# STIG recommendation: at least OptOut

<#
.SYNTAX
    Set-DataExecutionPrevention
        [-State] {OptIn | OptOut | AlwaysOn | AlwaysOff}
        [<CommonParameters>]
#>

function Set-DataExecutionPrevention
{
    <#
    .EXAMPLE
        PS> Set-DataExecutionPrevention -State 'OptOut'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('OptIn', 'OptOut', 'AlwaysOn', 'AlwaysOff')]
        [string] $State
    )

    process
    {
        Write-Verbose -Message "Setting 'Data Execution Prevention' to '$State'"
        bcdedit.exe -Set '{current}' nx $State | Out-Null
    }
}
