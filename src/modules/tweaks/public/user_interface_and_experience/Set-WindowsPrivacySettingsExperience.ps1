#=================================================================================================================
#                                       Windows Privacy Settings Experience
#=================================================================================================================

# Users may see privacy setting screens on first login or after an upgrade.

<#
.SYNTAX
    Set-WindowsPrivacySettingsExperience
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-WindowsPrivacySettingsExperience
{
    <#
    .EXAMPLE
        PS> Set-WindowsPrivacySettingsExperience -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > OOBE
        #   don't launch privacy settings experience on user logon
        # not configured: delete (default) | on: 1
        $WindowsPrivacySettingsExperienceGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\OOBE'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisablePrivacyExperience'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Privacy Settings Experience (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $WindowsPrivacySettingsExperienceGpo
    }
}
