#=================================================================================================================
#                              Font Providers (aka Font Streaming or Font On Demand)
#=================================================================================================================

# This feature allows Windows to download and temporarily install fonts (in memory)
# that are not already present on the device when they are needed.

# Automatically downloading and installing fonts that are not present on the system
# can raise security concerns. Only download fonts from trusted sources.

# CIS recommendation: Disabled

<#
.SYNTAX
    Set-FontProviders
        [-GPO] {Disabled | Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-FontProviders
{
    <#
    .EXAMPLE
        PS> Set-FontProviders -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoState] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > network > fonts
        #   enable font providers
        # not configured: delete (default) | on: 1 | off: 0
        $FontProvidersGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\System'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'EnableFontProviders'
                    Value = $GPO -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Font Providers (aka Font Streaming or Font On Demand) (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $FontProvidersGpo
    }
}
