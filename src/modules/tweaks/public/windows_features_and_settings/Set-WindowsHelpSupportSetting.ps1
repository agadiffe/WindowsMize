#=================================================================================================================
#                                        Windows Help And Support Setting
#=================================================================================================================

<#
.SYNTAX
    Set-WindowsHelpSupportSetting
        [-F1Key {Disabled | Enabled}]
        [-FeedbackGPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WindowsHelpSupportSetting
{
    <#
    .EXAMPLE
        PS> Set-WindowsHelpSupportSetting -F1Key 'Disabled' -FeedbackGPO 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $F1Key,

        [GpoStateWithoutEnabled] $FeedbackGPO
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'F1Key'
            {
                # on: delete (default) | off: empty value
                $HelpSupportF1Key = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64'
                    Entries = @(
                        @{
                            RemoveEntry = $F1Key -eq 'Enabled'
                            Name  = '(Default)'
                            Value = ''
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Windows Help And Support - F1 Key' to '$F1Key' ..."
                Set-RegistryEntry -InputObject $HelpSupportF1Key
            }
            'FeedbackGPO'
            {
                $IsNotConfigured = $FeedbackGPO -eq 'NotConfigured'

                # gpo\ user config > administrative tpl > system > internet communication management > internet communication settings
                #   turn off help experience improvement program
                #   turn off help ratings
                # not configured: delete (default) | on: 1
                $HelpSupportFeedbackGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Assistance\Client\1.0'
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'NoImplicitFeedback'
                            Value = '1'
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'NoExplicitFeedback'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Windows Help And Support - Feedback (GPO)' to '$FeedbackGPO' ..."
                Set-RegistryEntry -InputObject $HelpSupportFeedbackGpo
            }
        }
    }
}
