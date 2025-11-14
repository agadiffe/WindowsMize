#=================================================================================================================
#                                 System Properties - Remote > Remote Assistance
#=================================================================================================================

<#
.SYNTAX
    Set-RemoteAssistanceState
        [-State] {Disabled | FullControl | ViewOnly}
        [[-InvitationMaxTime] <int>]
        [[-InvitationMaxTimeUnit] {Minutes | Hours | Days}]
        [-EncryptedOnly {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-RemoteAssistanceState
{
    <#
    .EXAMPLE
        PS> Set-RemoteAssistanceState -State 'Disabled'

    .EXAMPLE
        PS> $RemoteAssistanceProperties = @{
                State                 = 'Enabled'
                InvitationMaxTime     = 42
                InvitationMaxTimeUnit = 'Minutes'
                InvitationMethod      = 'SimpleMAPI'
                EncryptedOnly         = 'Enabled'
            }
        PS> Set-RemoteAssistanceState @RemoteAssistanceProperties
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [RemoteAssistanceState] $State,

        [Parameter(Position = 1)]
        [ValidateRange(1, 99)]
        [int] $InvitationMaxTime = 6,

        [Parameter(Position = 2)]
        [TimeUnitMHD] $InvitationMaxTimeUnit = 'Hours',

        [state] $EncryptedOnly = 'Enabled'
    )

    process
    {
        $GetHelp, $FullControl = switch ($State)
        {
            'Disabled'    { '0', '0' }
            'FullControl' { '1', '1' }
            'ViewOnly'    { '1', '0' }
        }

        # on: 1 (default) | off: 0
        $RemoteAssistance = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\Remote Assistance'
            Entries = @(
                @{
                    Name  = 'fAllowToGetHelp'
                    Value = $GetHelp
                    Type  = 'DWord'
                }
                @{
                    Name  = 'fAllowFullControl'
                    Value = $FullControl
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Remote Assistance' to '$State' ..."
        Set-RegistryEntry -InputObject $RemoteAssistance

        Write-Verbose -Message "  set 'Firewall rules (group: @FirewallAPI.dll,-33002)' to '$State'"
        Set-NetFirewallRule -Group '@FirewallAPI.dll,-33002' -Enabled ($State -ne 'Disabled' ? 'True' : 'False')

        if ($State -ne 'Disabled')
        {
            # CreateEncryptedOnlyTickets\ on: 1 | off: 0 (default)
            # MaxTicketExpiry\ default: 6 (range 1-99)
            # MaxTicketExpiryUnits\ minutes: 0 | hours: 1 (default) | days: 2
            $RemoteAssistanceInvitations = @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SYSTEM\CurrentControlSet\Control\Remote Assistance'
                Entries = @(
                    @{
                        Name  = 'CreateEncryptedOnlyTickets'
                        Value = $EncryptedOnly -eq 'Enabled' ? '1' : '0'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'MaxTicketExpiry'
                        Value = [string]$InvitationMaxTime
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'MaxTicketExpiryUnits'
                        Value = [int]$InvitationMaxTimeUnit
                        Type  = 'DWord'
                    }
                )
            }

            $InvitationState = "$InvitationMaxTime $InvitationMaxTimeUnit (EncryptedOnly: $EncryptedOnly)'"
            Write-Verbose -Message "Setting 'Remote Assistance Invitations' to '$InvitationState' ..."
            Set-RegistryEntry -InputObject $RemoteAssistanceInvitations
        }
    }
}


<#
.SYNTAX
    Set-RemoteAssistanceGpo
        [-State] {Disabled | FullControl | ViewOnly | NotConfigured}
        [[-InvitationMaxTime] <int>]
        [[-InvitationMaxTimeUnit] {Minutes | Hours | Days}]
        [[-InvitationMethod] {SimpleMAPI | Mailto}]
        [-EncryptedOnly {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-RemoteAssistanceGpo
{
    <#
    .EXAMPLE
        PS> Set-RemoteAssistanceGpo -State 'Disabled'

    .EXAMPLE
        PS> $RemoteAssistanceGpoProperties = @{
                State                 = 'Enabled'
                InvitationMaxTime     = 42
                InvitationMaxTimeUnit = 'Minutes'
                InvitationMethod      = 'SimpleMAPI'
                EncryptedOnly         = 'Enabled'
            }
        PS> Set-RemoteAssistanceGpo @RemoteAssistanceGpoProperties
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [RemoteAssistanceGpoState] $State,

        [Parameter(Position = 1)]
        [ValidateRange(1, 99)]
        [int] $InvitationMaxTime = 6,

        [Parameter(Position = 2)]
        [TimeUnitMHD] $InvitationMaxTimeUnit = 'Hours',

        [Parameter(Position = 3)]
        [InvitationMethod] $InvitationMethod = 'SimpleMAPI',

        [GpoState] $EncryptedOnly = 'NotConfigured'
    )

    process
    {
        $IsDisabledOrNotConfigured = @('Disabled', 'NotConfigured') -contains $State
        $GetHelp, $FullControl = switch ($State)
        {
            'Disabled'    { '0', '0' }
            'FullControl' { '1', '1' }
            'ViewOnly'    { '1', '0' }
        }

        # gpo\ computer config > administrative tpl > system > remote assistance
        #   configure solicited remote assistance
        # not configured: delete (default)
        # off\ fAllowToGetHelp: 0, others: delete
        # allow helpers to remotely control the computer\ fAllowToGetHelp: 1, fAllowFullControl: 1
        # allow helpers to only view the computer\ fAllowToGetHelp: 1, fAllowFullControl: 0
        # maximum ticket time value (MaxTicketExpiry)\ default: 1 (range 1-99)
        # maximum ticket time units (MaxTicketExpiryUnits)\ minutes: 0 | hours: 1 (default) | days: 2
        # method for sending email invitations (fUseMailto)\ simple MAPI: 0 (default) | mailto: 1
        $RemoteAssistanceGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'NotConfigured' -and $State -ne 'Disabled'
                    Name  = 'fAllowToGetHelp'
                    Value = $GetHelp
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsDisabledOrNotConfigured
                    Name  = 'fAllowFullControl'
                    Value = $FullControl
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsDisabledOrNotConfigured
                    Name  = 'MaxTicketExpiry'
                    Value = [string]$InvitationMaxTime
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsDisabledOrNotConfigured
                    Name  = 'MaxTicketExpiryUnits'
                    Value = [int]$InvitationMaxTimeUnit
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsDisabledOrNotConfigured
                    Name  = 'fUseMailto'
                    Value = [int]$InvitationMethod
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Remote Assistance (GPO)' to '$State' ..."
        Set-RegistryEntry -InputObject $RemoteAssistanceGpo


        # gpo\ computer config > administrative tpl > system > remote assistance
        #   allow only Windows Vista or later connections
        # not configured: delete (default) | on: 1 | off: 0
        $RemoteAssistanceEncryptedOnlyGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
            Entries = @(
                @{
                    RemoveEntry = $EncryptedOnly -eq 'NotConfigured'
                    Name  = 'CreateEncryptedOnlyTickets'
                    Value = $EncryptedOnly -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Remote Assistance EncryptedOnly (GPO)' to '$EncryptedOnly' ..."
        Set-RegistryEntry -InputObject $RemoteAssistanceEncryptedOnlyGpo
    }
}
