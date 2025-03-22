#=================================================================================================================
#                                            Windows Shared Experience
#=================================================================================================================

# Disable and gray out:
#   settings > system > nearby sharing
#   settings > apps > advanced app settings > share across devices

<#
.SYNTAX
    Set-WindowsSharedExperience
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-WindowsSharedExperience
{
    <#
    .EXAMPLE
        PS> Set-WindowsSharedExperience -GPO 'Disabled'
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
        #   continue experiences on this device
        # not configured: delete (default) | off: 0
        $WindowsSharedExperienceGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\System'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'EnableCdp'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Shared Experience (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $WindowsSharedExperienceGpo
    }
}
