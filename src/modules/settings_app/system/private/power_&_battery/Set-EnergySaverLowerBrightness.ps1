#=================================================================================================================
#                        System > Power & Battery > Energy Saver > Lower Screen Brightness
#=================================================================================================================

<#
.SYNTAX
    Set-EnergySaverLowerBrightness
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-EnergySaverLowerBrightness
{
    <#
    .EXAMPLE
        PS> Set-EnergySaverLowerBrightness -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 70 (default) (range 0-99) | off: 100
        $Value = $State -eq 'Enabled' ? 70 : 100

        Write-Verbose -Message "Setting 'Energy Saver - Lower Screen Brightness' to '$State' ..."

        powercfg.exe -SetACValueIndex SCHEME_CURRENT SUB_ENERGYSAVER ESBRIGHTNESS $Value
        powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_ENERGYSAVER ESBRIGHTNESS $Value
    }
}
