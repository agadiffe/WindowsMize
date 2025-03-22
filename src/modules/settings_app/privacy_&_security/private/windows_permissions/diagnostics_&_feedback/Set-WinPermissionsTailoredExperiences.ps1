#=================================================================================================================
#                       Privacy & Security > Diagnostics & Feedback > Tailored Experiences
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsTailoredExperiences
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsTailoredExperiences
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsTailoredExperiences -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $WinPermissionsTailoredExperiencesMsg = 'Windows Permissions - Diagnostics & Feedback: Tailored Experiences'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $WinPermissionsTailoredExperiences = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Privacy'
                    Entries = @(
                        @{
                            Name  = 'TailoredExperiencesWithDiagnosticDataEnabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsTailoredExperiencesMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinPermissionsTailoredExperiences
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > windows components > cloud content
                #   do not use diagnostic data for tailored experiences
                # not configured: delete (default) | on: 1
                $WinPermissionsTailoredExperiencesGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Windows\CloudContent'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DisableTailoredExperiencesWithDiagnosticData'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsTailoredExperiencesMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsTailoredExperiencesGpo
            }
        }
    }
}
