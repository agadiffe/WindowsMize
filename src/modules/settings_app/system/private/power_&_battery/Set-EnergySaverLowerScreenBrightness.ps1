#=================================================================================================================
#                        System > Power & Battery > Energy Saver > Lower Screen Brightness
#=================================================================================================================

<#
.SYNTAX
    Set-EnergySaverLowerScreenBrightness
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-EnergySaverLowerScreenBrightness
{
    <#
    .EXAMPLE
        PS> Set-EnergySaverLowerScreenBrightness -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # SUB_ENERGYSAVER: 'de830923-a562-41af-a086-e3a2c6bad2da'
        # ESBRIGHTNESS: '13d09884-f74e-474a-a852-b6bde8ad03a8'

        Write-Verbose -Message "Setting 'Energy Saver - Lower Screen Brightness' to '$State' ..."

        $PowerPlanGUID = Get-PowerPlanGUID
        $Value = $State -eq 'Enabled' ? 70 : 100

        foreach ($GUID in $PowerPlanGUID)
        {
            # on: 70 (default) (range: 0-99) | off: 100
            powercfg.exe -SetACValueIndex $GUID SUB_ENERGYSAVER ESBRIGHTNESS $Value
            powercfg.exe -SetDCValueIndex $GUID SUB_ENERGYSAVER ESBRIGHTNESS $Value
        }

        powercfg.exe -SetActive SCHEME_CURRENT
    }
}
