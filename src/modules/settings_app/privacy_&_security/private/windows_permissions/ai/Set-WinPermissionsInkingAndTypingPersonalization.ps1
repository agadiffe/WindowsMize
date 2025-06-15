#=================================================================================================================
#           Privacy & Security > Inking & Typing Personalization > Custom Inking And Typing Dictionary
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsInkingAndTypingPersonalization
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinPermissionsInkingAndTypingPersonalization
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsInkingAndTypingPersonalization -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $IsEnabled = $State -eq 'Enabled'

        # on: 0 0 1 1 1 (default) | off: 1 1 0 0 0
        $WinPermissionsInkingAndTypingPersonalization = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\InputPersonalization'
                Entries = @(
                    @{
                        Name  = 'RestrictImplicitInkCollection'
                        Value = $IsEnabled ? '0' : '1'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'RestrictImplicitTextCollection'
                        Value = $IsEnabled ? '0' : '1'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\InputPersonalization\TrainedDataStore'
                Entries = @(
                    @{
                        Name  = 'HarvestContacts'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Personalization\Settings'
                Entries = @(
                    @{
                        Name  = 'AcceptedPrivacyPolicy'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization'
                Entries = @(
                    @{
                        Name  = 'Value'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Windows Permissions - Inking & Typing Personalization' to '$State' ..."
        $WinPermissionsInkingAndTypingPersonalization | Set-RegistryEntry
    }
}
