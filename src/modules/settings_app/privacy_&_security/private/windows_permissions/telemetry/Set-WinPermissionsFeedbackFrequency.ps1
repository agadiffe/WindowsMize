#=================================================================================================================
#                        Privacy & Security > Diagnostics & Feedback > Feedback Frequency
#=================================================================================================================

# The group policy also remove the setting from the GUI.

<#
.SYNTAX
    Set-WinPermissionsFeedbackFrequency
        [[-State] {Never | Automatically | Always | Daily | Weekly}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsFeedbackFrequency
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsFeedbackFrequency -State 'Never' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [FeedbackFrequencyMode] $State,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $WinPermissionsFeedbackFrequencyMsg = 'Windows Permissions - Diagnostics & Feedback: Feedback Frequency'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                $NumberOfSIUF, $NanoSeconds = switch ($State)
                {
                    'Never'         { '0', '' }
                    'Always'        { '', '100000000' }
                    'Daily'         { '1', '864000000000' }
                    'Weekly'        { '1', '6048000000000' }
                }

                $IsAuto = $State -eq 'Automatically'

                # automatically: delete delete (default) | always: delete 100000000
                # once a day: 1 864000000000 | once a week: 1 6048000000000 | never: 0 delete
                $WinPermissionsFeedbackFrequency = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Siuf\Rules'
                    Entries = @(
                        @{
                            RemoveEntry = $IsAuto -or $State -eq 'Always'
                            Name  = 'NumberOfSIUFInPeriod'
                            Value = $NumberOfSIUF
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsAuto -or $State -eq 'Never'
                            Name  = 'PeriodInNanoSeconds'
                            Value = $NanoSeconds
                            Type  = 'QWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsFeedbackFrequencyMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinPermissionsFeedbackFrequency
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > data collection and preview builds
                #   do not show feedback notifications
                # not configured: delete (default) | on: 1
                $WinPermissionsFeedbackFrequencyGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\DataCollection'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DoNotShowFeedbackNotifications'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsFeedbackFrequencyMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsFeedbackFrequencyGpo
            }
        }
    }
}
