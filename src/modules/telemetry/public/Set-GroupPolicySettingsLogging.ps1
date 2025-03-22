#=================================================================================================================
#                                    Telemetry - Group Policy Settings Logging
#=================================================================================================================

# If Group Policy settings are modified directly through registry entries instead of using
# Group Policy Editor tool, RSoP logging might not capture these changes accurately.
# However, this limitation does not negate the overall value of keeping RSoP logging enabled,
# given its minimal resource usage and troubleshooting benefits.

<#
.SYNTAX
    Set-GroupPolicySettingsLogging
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-GroupPolicySettingsLogging
{
    <#
    .EXAMPLE
        PS> Set-GroupPolicySettingsLogging -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > system > group policy
        #   turn off resultant set of policy logging
        # not configured: delete (default) | on: 0
        $GroupPolicySettingsLoggingGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\System'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'RSoPLogging'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Group Policy Settings Logging (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $GroupPolicySettingsLoggingGpo
    }
}
