#=================================================================================================================
#                                        Test Modern Standby Availability
#=================================================================================================================

<#
.SYNTAX
    Test-ModernStandbyAvailability [<CommonParameters>]
#>

function Test-ModernStandbyAvailability
{
    [CmdletBinding()]
    param()

    process
    {
        $PowercfgOutput = powercfg.exe /a
        $AvailableStates = $PowercfgOutput | Select-Object -First $PowercfgOutput.IndexOf("")
        [bool]($AvailableStates -match 'S0')
    }
}
