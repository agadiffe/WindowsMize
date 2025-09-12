#=================================================================================================================
#                               Network - Web Proxy Auto-Discovery protocol (WPAD)
#=================================================================================================================

# Disabling WPAD will make the 'Automatically detect settings' option in proxy settings non-functional.
# Proxies will need to be configured manually.
# windows settings app > network & internet > proxy > automatically detect settings

# Attackers may abuse the WPAD auto-config functionality to supply computers with a PAC file
# that specifies a rogue web proxy under their control (Man-in-the-middle (MITM) attack).

# CIS recommendation: Disabled

<#
.SYNTAX
    Set-NetProxyAutoDetect
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NetProxyAutoDetect
{
    <#
    .EXAMPLE
        PS> Set-NetProxyAutoDetect -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: delete (default) | off: 1
        $NetworkWpad = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp'
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'Enabled'
                    Name  = 'DisableWpad'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Network - Web Proxy Auto-Discovery protocol (WPAD)' to '$State' ..."
        Set-RegistryEntry -InputObject $NetworkWpad
    }
}
