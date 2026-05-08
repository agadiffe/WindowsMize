#=================================================================================================================
#                                         System > Advanced > Enable Sudo
#=================================================================================================================

<#
.SYNTAX
    Set-SudoCommand
        [-Mode] {Disabled | NewWindow | InputDisabled | Inline}
        [<CommonParameters>]
#>

function Set-SudoCommand
{
    <#
    .EXAMPLE
        PS> Set-SudoCommand -Mode 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [SudoMode] $Mode
    )

    process
    {
        # disabled: disable (default) | in a new window: forceNewWindow | with input disabled: disableInput | inline: normal
        $SettingValue = switch ($Mode)
        {
            'NewWindow'     { 'forceNewWindow' }
            'InputDisabled' { 'disableInput' }
            'Inline'        { 'normal' }
            'Disabled'      { 'disable' }
        }

        Write-Verbose -Message "Setting 'System Advanced - Sudo Command' to '$Mode' ..."

        if (-not (Get-Command 'sudo.exe' -ErrorAction 'SilentlyContinue'))
        {
            Write-Verbose "  the 'sudo' command is not available on this system"
        }
        else
        {
            sudo config --enable $SettingValue | Out-Null
        }
    }
}
