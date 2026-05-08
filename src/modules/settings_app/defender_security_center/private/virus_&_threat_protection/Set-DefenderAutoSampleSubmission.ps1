#=================================================================================================================
#                  Defender > Virus & Threat Protection > Settings > Automatic Sample Submission
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderAutoSampleSubmission
        [[-Consent] {NeverSend | AlwaysPrompt | SendSafeSamples | SendAllSamples}]
        [-GPO {NeverSend | AlwaysPrompt | SendSafeSamples | SendAllSamples | NotConfigured}]
        [<CommonParameters>]
#>

function Set-DefenderAutoSampleSubmission
{
    <#
    .EXAMPLE
        PS> Set-DefenderAutoSampleSubmission -Consent 'NeverSend' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [SampleSubmissionMode] $Consent,

        [GpoSampleSubmissionMode] $GPO
    )

    process
    {
        $DefenderAutoSampleSubmissionMsg = 'Defender - Automatic Sample Submission'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # AlwaysPrompt | SendSafeSamples (default) | NeverSend | SendAllSamples
                Write-Verbose -Message "Setting '$DefenderAutoSampleSubmissionMsg' to '$Consent' ..."
                Set-MpPreference -SubmitSamplesConsent $Consent
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > microsoft defender antivirus > MAPS
                #   send file samples when further analysis is required
                # not configured: delete (default) | always prompt: 0 | send safe samples: 1 | never send: 2 | send all samples: 3
                $DefenderAutoSampleSubmissionGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows Defender\Spynet'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'SubmitSamplesConsent'
                            Value = [int]$GPO
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$DefenderAutoSampleSubmissionMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $DefenderAutoSampleSubmissionGpo
            }
        }
    }
}
