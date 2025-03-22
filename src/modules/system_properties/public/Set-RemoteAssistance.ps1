#=================================================================================================================
#                                 System Properties - Remote > Remote Assistance
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

# Remote assistance allows another user to view or take control of the local session of a user.
# Solicited assistance is help that is specifically requested by the local user.
# This may allow unauthorized parties access to the resources on the computer.

# Allow remote assistance connections to this computer (ViewOnly)
#   Allow this computer to be controlled remotely (FullControl)
#   Set the maximum amount of time invitations can remain open (InvitationMaxTime & InvitationMaxTimeUnit)
#   Create invitations that can only be used from computers running Windows Vista or later (EncryptedOnly)

# default: Enabled
# STIG recommendation: Disabled

<#
.SYNTAX
    Set-RemoteAssistance
        [[-State] {Disabled | FullControl | ViewOnly}]
        [-GPO {Disabled | FullControl | ViewOnly | NotConfigured}]
        [-InvitationMaxTime <int>]
        [-InvitationMaxTimeUnit {Minutes | Hours | Days}]
        [-EncryptedOnly {Disabled | Enabled}]
        [-EncryptedOnlyGPO {Disabled | Enabled | NotConfigured}]
        [-InvitationMethodGPO {SimpleMAPI | Mailto}]
        [<CommonParameters>]
#>

function Set-RemoteAssistance
{
    <#
    .EXAMPLE
        PS> Set-RemoteAssistance -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [RemoteAssistanceState] $State,

        [RemoteAssistanceGpoState] $GPO,

        [ValidateRange(1, 99)]
        [int] $InvitationMaxTime = 6,

        [TimeUnitMHD] $InvitationMaxTimeUnit = 'Hours',

        [state] $EncryptedOnly = 'Enabled',

        [GpoState] $EncryptedOnlyGPO = 'NotConfigured',

        [InvitationMethod] $InvitationMethodGPO = 'SimpleMAPI'
    )

    process
    {
        if (-not ($PSBoundParameters.ContainsKey('State') -or $PSBoundParameters.ContainsKey('GPO')))
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            Write-Error -Message 'Specify at least the ''State'' or ''GPO'' parameter.'
            return
        }

        $InvitationProperties = @{
            InvitationMaxTime     = $InvitationMaxTime
            InvitationMaxTimeUnit = $InvitationMaxTimeUnit
        }

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                $RemoteAssistanceProperties = @{
                    State         = $State
                    EncryptedOnly = $EncryptedOnly
                }
                Set-RemoteAssistanceState @RemoteAssistanceProperties @InvitationProperties
            }
            'GPO'
            {
                $RemoteAssistancePropertiesGpo = @{
                    State            = $GPO
                    EncryptedOnly    = $EncryptedOnlyGPO
                    InvitationMethod = $InvitationMethodGPO
                }
                Set-RemoteAssistanceGpo @RemoteAssistancePropertiesGpo @InvitationProperties
            }
        }
    }
}
