#=================================================================================================================
#                                        Microsoft Store - Push To Install
#=================================================================================================================

# Instal apps from the Microsoft Store running on other devices or the web.

# CIS Recommendation: Disabled

<#
.SYNTAX
    Set-MicrosoftStorePushToInstall
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MicrosoftStorePushToInstall
{
    <#
    .EXAMPLE
        PS> Set-MicrosoftStorePushToInstall -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > push to install
        #   turn off push to install service
        # not configured: delete (default) | on: 1

        $MSStorePushToInstallGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\PushToInstall'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisablePushToInstall'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Microsoft Store - Push To Install (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSStorePushToInstallGpo
    }
}
