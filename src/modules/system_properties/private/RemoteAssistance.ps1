#=================================================================================================================
#                                 System Properties - Remote > Remote Assistance
#=================================================================================================================

<#
.SYNTAX
    Set-RemoteAssistanceAccess
        [-Access] {Disabled | FullControl | ViewOnly}
        [[-InvitationMaxTime] <int>]
        [[-InvitationMaxTimeUnit] {Minutes | Hours | Days}]
        [-EncryptedOnly {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-RemoteAssistanceAccess
{
    <#
    .EXAMPLE
        PS> Set-RemoteAssistanceAccess -Access 'Disabled'

    .EXAMPLE
        PS> $RemoteAssistanceProperties = @{
                Access                = 'ViewOnly'
                InvitationMaxTime     = 42
                InvitationMaxTimeUnit = 'Minutes'
                InvitationMethod      = 'SimpleMAPI'
                EncryptedOnly         = 'Enabled'
            }
        PS> Set-RemoteAssistanceAccess @RemoteAssistanceProperties
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [RemoteAssistanceAccess] $Access,

        [Parameter(Position = 1)]
        [ValidateRange(1, 99)]
        [int] $InvitationMaxTime = 6,

        [Parameter(Position = 2)]
        [TimeUnitMHD] $InvitationMaxTimeUnit = 'Hours',

        [state] $EncryptedOnly = 'Enabled'
    )

    process
    {
        $GetHelp, $FullControl = switch ($Access)
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

        Write-Verbose -Message "Setting 'Remote Assistance' to '$Access' ..."
        Set-RegistryEntry -InputObject $RemoteAssistance

        $IsAccessDisabled = $Access -eq 'Disabled'
        $FirewallState = $IsAccessDisabled ? 'Disabled' : 'Enabled'
        Write-Verbose -Message "  set 'Firewall rules (group: @FirewallAPI.dll,-33002)' to '$FirewallState'"
        Set-NetFirewallRule -Group '@FirewallAPI.dll,-33002' -Enabled ($IsAccessDisabled ? 'False' : 'True')

        if (-not $IsAccessDisabled)
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
                        Value = $InvitationMaxTime
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'MaxTicketExpiryUnits'
                        Value = [int]$InvitationMaxTimeUnit
                        Type  = 'DWord'
                    }
                )
            }

            $InvitationMsg = "$InvitationMaxTime $InvitationMaxTimeUnit (EncryptedOnly: $EncryptedOnly)'"
            Write-Verbose -Message "Setting 'Remote Assistance Invitations' to '$InvitationMsg' ..."
            Set-RegistryEntry -InputObject $RemoteAssistanceInvitations
        }
    }
}


<#
.SYNTAX
    Set-RemoteAssistancePolicy
        [-GPO] {Disabled | FullControl | ViewOnly | NotConfigured}
        [[-InvitationMaxTime] <int>]
        [[-InvitationMaxTimeUnit] {Minutes | Hours | Days}]
        [[-InvitationMethod] {SimpleMAPI | Mailto}]
        [-EncryptedOnly {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-RemoteAssistancePolicy
{
    <#
    .EXAMPLE
        PS> Set-RemoteAssistancePolicy -GPO 'Disabled'

    .EXAMPLE
        PS> $RemoteAssistanceGpoProperties = @{
                GPO                   = 'ViewOnly'
                InvitationMaxTime     = 42
                InvitationMaxTimeUnit = 'Minutes'
                InvitationMethod      = 'SimpleMAPI'
                EncryptedOnly         = 'Enabled'
            }
        PS> Set-RemoteAssistancePolicy @RemoteAssistanceGpoProperties
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [RemoteAssistanceGpoAccess] $GPO,

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
        $IsDisabledOrNotConfigured = @('Disabled', 'NotConfigured') -contains $GPO
        $GetHelp, $FullControl = switch ($GPO)
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
                    RemoveEntry = $GPO -eq 'NotConfigured'
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
                    Value = $InvitationMaxTime
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

        Write-Verbose -Message "Setting 'Remote Assistance (GPO)' to '$GPO' ..."
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
