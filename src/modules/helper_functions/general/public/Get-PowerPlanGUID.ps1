#=================================================================================================================
#                                     Helper Function - Get Power Plans GUID
#=================================================================================================================

<#
.SYNTAX
    Get-PowerPlanGUID
        [-CurrentScheme]
        [<CommonParameters>]
#>

function Get-PowerPlanGUID
{
    <#
    .EXAMPLE
        PS> Get-PowerPlanGUID

    .EXAMPLE
        PS> Get-PowerPlanGUID -CurrentScheme
    #>

    [CmdletBinding()]
    param
    (
        [switch] $CurrentScheme
    )

    process
    {
        $PowerPlanParam = @{
            Namespace = 'root/cimv2/power'
            ClassName = 'Win32_PowerPlan'
            Verbose   = $false
        }

        if ($CurrentScheme)
        {
            $PowerPlanParam['Filter'] = 'IsActive = TRUE'
        }

        $PowerPlan = Get-CimInstance @PowerPlanParam
        $PowerPlanGUID = ($PowerPlan.InstanceID -replace '^.*\{|\}.*$').ToLower()
        $PowerPlanGUID
    }
}
