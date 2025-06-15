#=================================================================================================================
#                            Privacy & Security > App Permissions > Screenshot Borders
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsScreenshotBorders
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsScreenshotBorders
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsScreenshotBorders -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoState] $GPO
    )

    process
    {
        $ScreenshotBordersMsg = 'Screenshot Borders'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $ScreenshotBorders = [AppPermissionAccess]::new('graphicsCaptureWithoutBorder', $State)
                $ScreenshotBorders.WriteVerboseMsg($ScreenshotBordersMsg)
                $ScreenshotBorders.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps turn off the screenshot border
                # not configured: delete (default) | on: 1 | off: 2

                $ScreenshotBordersGpo = [AppPermissionPolicy]::new('LetAppsAccessGraphicsCaptureWithoutBorder', $GPO)
                $ScreenshotBordersGpo.WriteVerboseMsg("$ScreenshotBordersMsg (GPO)")
                $ScreenshotBordersGpo.SetRegistryEntry()
            }
        }
    }
}
