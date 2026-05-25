#=================================================================================================================
#                      Personnalization > Lock Screen > Suggest Widgets For Your Lock Screen
#=================================================================================================================

<#
.SYNTAX
    Set-LockScreenWidgetsSuggestion
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-LockScreenWidgetsSuggestion
{
    <#
    .EXAMPLE
        PS> Set-LockScreenWidgetsSuggestion -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $LockScreenWidgetsSuggestion = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Lock Screen'
            Entries = @(
                @{
                    Name  = 'LockScreenWidgetsSystemCurationEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Lock Screen - Suggest Widgets For Your Lock Screen' to '$State' ..."
        Set-RegistryEntry -InputObject $LockScreenWidgetsSuggestion
    }
}
