#=================================================================================================================
# Defender > Settings > Notifications > Virus & Threat Protection > Threats Found, But No Immediate Action Is Needed
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderNotifsThreatsFoundNoActionNeeded
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DefenderNotifsThreatsFoundNoActionNeeded
{
    <#
    .EXAMPLE
        PS> Set-DefenderNotifsThreatsFoundNoActionNeeded -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 (default) | off: 1
        $DefenderNotifsThreatsFoundNoActionNeeded = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection'
            Entries = @(
                @{
                    Name  = 'NoActionNotificationDisabled'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Defender Notifications - Threats found, but no immediate action is needed' to '$State' ..."
        Set-RegistryEntry -InputObject $DefenderNotifsThreatsFoundNoActionNeeded
    }
}
