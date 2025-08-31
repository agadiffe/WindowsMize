#=================================================================================================================
#                           Network & Internet > Proxy > Automatically Detect Settings
#=================================================================================================================

# See also: network > Set-NetProxyAutoDetect (Web Proxy Auto-Discovery protocol)

<#
.SYNTAX
    Set-ProxyAutoDetectSettings
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ProxyAutoDetectSettings
{
    <#
    .EXAMPLE
        PS> Set-ProxyAutoDetectSettings -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # 9th byte, 4th bit\ on: 1 (default) | off: 0
        $SettingRegPath = 'Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections'
        $SettingBytes = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name 'DefaultConnectionSettings'
        Set-ByteBitFlag -Bytes $SettingBytes -ByteNum 8 -BitPos 4 -State ($State -eq 'Enabled')
        $SettingBytes[4] = $SettingBytes[4] -eq 255 ? 2 : $SettingBytes[4] + 1 # counter

        $ProxyAutoDetectSettings = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections'
            Entries = @(
                @{
                    Name  = 'DefaultConnectionSettings'
                    Value = $SettingBytes
                    Type  = 'Binary'
                }
            )
        }

        Write-Verbose -Message "Setting 'Network Proxy - Automatically Detect Settings' to '$State' ..."
        Set-RegistryEntry -InputObject $ProxyAutoDetectSettings
    }
}
