#=================================================================================================================
#                           Accessibility > Speech > Keyboard Shorcut For Voice Typing
#=================================================================================================================

# default: Enabled

<#
.SYNTAX
    Set-VoiceTypingKeyboardShorcut
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-VoiceTypingKeyboardShorcut
{
    <#
    .EXAMPLE
        PS> Set-VoiceTypingKeyboardShorcut -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        Write-Verbose -Message "Setting 'Speech - Keyboard Shorcut For Voice Typing (Win + H)' to '$State' ..."
        Set-KeyboardHotkey -Value 'H' -State $State
    }
}
