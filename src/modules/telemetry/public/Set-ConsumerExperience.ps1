#=================================================================================================================
#                                        Telemetry - Consumer Experiences
#=================================================================================================================

# Turning off Microsoft consumer experiences will help prevent the unwanted installation of suggested applications.

# If disabled, disable and gray out: settings > bluetooth & devices > mobile devices

# STIG recommendation: Disabled

<#
.SYNTAX
    Set-ConsumerExperience
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-ConsumerExperience
{
    <#
    .EXAMPLE
        PS> Set-ConsumerExperience -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > cloud content
        #   turn off microsoft consumer experiences (only applies to Enterprise and Education SKUs)
        # not configured: delete (default) | on: 1
        $ConsumerExperienceGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\CloudContent'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableWindowsConsumerFeatures'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Consumer Experiences (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $ConsumerExperienceGpo
    }
}
