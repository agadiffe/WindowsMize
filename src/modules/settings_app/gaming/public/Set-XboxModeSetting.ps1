#=================================================================================================================
#                                          Gaming > Xbox Mode - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-XboxModeSetting
        [-XboxMode {Disabled | Enabled}]
        [-ShowInTaskView {Disabled | Enabled}]
        [-ShowControlHintsInTaskView {Disabled | Enabled}]
        [-ConfirmationPrompts {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-XboxModeSetting
{
    <#
    .EXAMPLE
        PS> Set-XboxModeSetting -XboxMode 'Disabled' -ShowInTaskView 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $XboxMode,

        [state] $ShowInTaskView,

        [state] $ShowControlHintsInTaskView,

        [state] $ConfirmationPrompts
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
            'XboxMode'                   { Set-XboxMode -State $XboxMode }
            'ShowInTaskView'             { Set-XboxModeShowInTaskView -State $ShowInTaskView }
            'ShowControlHintsInTaskView' { Set-XboxModeShowControlHintsInTaskView -State $ShowControlHintsInTaskView }
            'ConfirmationPrompts'        { Set-XboxModeConfirmationPrompts -State $ConfirmationPrompts }
        }
    }
}
