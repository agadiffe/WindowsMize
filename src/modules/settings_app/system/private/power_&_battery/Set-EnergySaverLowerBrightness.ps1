#=================================================================================================================
#                        System > Power & Battery > Energy Saver > Lower Screen Brightness
#=================================================================================================================

# You can set a custom brightness level for energy-saving mode.
# If you later disable and re-enable this feature through the graphical user interface (GUI):
#   Your custom setting will not be retained.
#   It will revert to the default energy-saving brightness level.

<#
.SYNTAX
    Set-EnergySaverLowerBrightness
        [-Percent] <int>
        [<CommonParameters>]
#>

function Set-EnergySaverLowerBrightness
{
    <#
    .EXAMPLE
        PS> Set-EnergySaverLowerBrightness -Percent 70
    #>

    [CmdletBinding()]
    param
    (
        [ValidateRange(0, 100)]
        [int] $Percent
    )

    process
    {
        # on: 70 (default) (range 0-99) | off: 100
        $State = switch ($Percent)
        {
            100     { 'Disabled' }
            Default { "Enabled ($Percent%)" }
        }

        Write-Verbose -Message "Setting 'Energy Saver - Lower Screen Brightness' to '$State' ..."

        powercfg.exe -SetACValueIndex SCHEME_CURRENT SUB_ENERGYSAVER ESBRIGHTNESS $Percent
        powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_ENERGYSAVER ESBRIGHTNESS $Percent
    }
}
