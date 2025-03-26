#=================================================================================================================
#                         Personnalization > Taskbar > System Tray Icons > Emoji And More
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarEmojiAndMore
        [-Value] {Never | WhileTyping | Always}
        [<CommonParameters>]
#>

function Set-TaskbarEmojiAndMore
{
    <#
    .EXAMPLE
        PS> Set-TaskbarEmojiAndMore -Value 'Never'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [EmojiMode] $Value
    )

    process
    {
        # Never: 0 | WhileTyping: 1 (default) | Always: 2
        $TaskbarTrayIconsEmojiAndMore = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\TabletTip\1.7'
            Entries = @(
                @{
                    Name  = 'EmojiAndMoreIconVisibilityState'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar Tray Icons - Emoji And More' to '$Value' ..."
        Set-RegistryEntry -InputObject $TaskbarTrayIconsEmojiAndMore
    }
}
