#=================================================================================================================
#                         System > Multitasking > Snap Windows > Suggest What I Can Snap
#=================================================================================================================

# When I snap a window, suggest what I can snap next to it

<#
.SYNTAX
    Set-SnapSuggestions
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SnapSuggestions
{
    <#
    .EXAMPLE
        PS> Set-SnapSuggestions -State 'Disabled'
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
        $SnapSuggestions = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'SnapAssist'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Snap Windows - Suggest What I Can Snap Next To It' to '$State' ..."
        Set-RegistryEntry -InputObject $SnapSuggestions
    }
}
