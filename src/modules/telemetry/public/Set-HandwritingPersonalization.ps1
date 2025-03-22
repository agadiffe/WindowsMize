#=================================================================================================================
#                                     Telemetry - Handwriting Personalization
#=================================================================================================================

# This setting prevents data from the handwriting recognition personalization tool being shared with Microsoft.

# STIG recommendation: Disabled (mentionned for Windows 7/8, not mentionned for Windows 11)

<#
.SYNTAX
    Set-HandwritingPersonalization
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-HandwritingPersonalization
{
    <#
    .EXAMPLE
        PS> Set-HandwritingPersonalization -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $IsNotConfigured = $GPO -eq 'NotConfigured'

        # gpo\ computer config > administrative tpl > control panel > regional and language options > handwriting personalization
        #   turn off automatic learning
        # not configured: delete (default) | off: 0 0 | on: 1 1
        #
        # gpo\ computer config > administrative tpl > system > internet communication management > internet communication settings
        #   turn off handwriting personalization data sharing
        #   turn off handwriting recognition error reporting
        # not configured: delete (default) | off: 0 delete | on: 1 1
        $HandwritingGpo = @(
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Microsoft\InputPersonalization'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'RestrictImplicitInkCollection'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'RestrictImplicitTextCollection'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Microsoft\Windows\TabletPC'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'PreventHandwritingDataSharing'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'PreventHandwritingErrorReports'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Handwriting Personalization (GPO)' to '$GPO' ..."
        $HandwritingGpo | Set-RegistryEntry
    }
}
