#=================================================================================================================
#                                         System > Advanced > Enable Sudo
#=================================================================================================================

<#
.SYNTAX
    Set-SudoCommand
        [-Value] {Disabled | NewWindow | InputDisabled | Inline}
        [<CommonParameters>]
#>

function Set-SudoCommand
{
    <#
    .EXAMPLE
        PS> Set-SudoCommand -Value 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [SudoMode] $Value
    )

    process
    {
        # disabled: disable (default) | in a new window: forceNewWindow | with input disabled: disableInput | inline: normal
        $SettingValue = switch ($Value)
        {
            'NewWindow'     { 'forceNewWindow' }
            'InputDisabled' { 'disableInput' }
            'Inline'        { 'normal' }
            'Disabled'      { 'disable' }
        }

        Write-Verbose -Message "Setting 'System Advanced - Sudo Command' to '$Value' ..."
        sudo config --enable $SettingValue | Out-Null
    }
}
