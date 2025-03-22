#=================================================================================================================
#                                     System > Clipboard > Suggested Actions
#=================================================================================================================

# This feature is deprecated.

<#
.SYNTAX
    Set-ClipboardSuggestedActions
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ClipboardSuggestedActions
{
    <#
    .EXAMPLE
        PS> Set-ClipboardSuggestedActions -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 (default) | off: 1
        $ClipboardSuggestedActions = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\SmartActionPlatform\SmartClipboard'
            Entries = @(
                @{
                    Name  = 'Disabled'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Clipboard - Suggested Actions' to '$State' ..."
        Set-RegistryEntry -InputObject $ClipboardSuggestedActions
    }
}
