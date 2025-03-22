#=================================================================================================================
#                           Windows Media Digital Rights Management (DRM) Online Access
#=================================================================================================================

<#
.SYNTAX
    Set-WindowsMediaDrmOnlineAccess
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-WindowsMediaDrmOnlineAccess
{
    <#
    .EXAMPLE
        PS> Set-WindowsMediaDrmOnlineAccess -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > windows media digital rights management
        #   prevent Windows Media DRM Internet Access
        # not configured: delete (default) | on: 1
        $WindowsMediaDrmOnlineAccessGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\WMDRM'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableOnline'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Media Digital Rights Management (DRM) Online Access (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $WindowsMediaDrmOnlineAccessGpo
    }
}
