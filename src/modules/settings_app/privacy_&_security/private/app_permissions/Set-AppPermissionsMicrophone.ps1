#=================================================================================================================
#                                Privacy & Security > App Permissions > Microphone
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsMicrophone
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsMicrophone
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsMicrophone -State 'Disabled' -GPO 'NotConfigured'
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
        $MicrophoneMsg = 'Microphone'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $Microphone = [AppPermissionAccess]::new('microphone', $State)
                $Microphone.WriteVerboseMsg($MicrophoneMsg)
                $Microphone.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps access the microphone
                # not configured: delete (default) | on: 1 | off: 2

                $MicrophoneGpo = [AppPermissionPolicy]::new('LetAppsAccessMicrophone', $GPO)
                $MicrophoneGpo.WriteVerboseMsg("$MicrophoneMsg (GPO)")
                $MicrophoneGpo.SetRegistryEntry()
            }
        }
    }
}
