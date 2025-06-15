#=================================================================================================================
#                     Privacy & Security > App Permissions > Screenshots And Screen Recording
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsScreenshotsAndRecording
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsScreenshotsAndRecording
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsScreenshotsAndRecording -State 'Disabled' -GPO 'NotConfigured'
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
        $ScreenshotsAndRecordingMsg = 'Screenshots And Screen Recording'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $ScreenshotsAndRecording = [AppPermissionAccess]::new('graphicsCaptureProgrammatic', $State)
                $ScreenshotsAndRecording.WriteVerboseMsg($ScreenshotsAndRecordingMsg)
                $ScreenshotsAndRecording.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps take screenshots of various windows or displays
                # not configured: delete (default) | on: 1 | off: 2

                $ScreenshotsAndRecordingGpo = [AppPermissionPolicy]::new('LetAppsAccessGraphicsCaptureProgrammatic', $GPO)
                $ScreenshotsAndRecordingGpo.WriteVerboseMsg("$ScreenshotsAndRecordingMsg (GPO)")
                $ScreenshotsAndRecordingGpo.SetRegistryEntry()
            }
        }
    }
}
