#=================================================================================================================
#                                          System > Advanced - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-SystemAdvancedSetting
        [-EndTask {Disabled | Enabled}]
        [-ModernRunDialog {Disabled | Enabled}]
        [-LongPaths {Disabled | Enabled}]
        [-Sudo {Disabled | NewWindow | InputDisabled | Inline}]
        [<CommonParameters>]
#>

function Set-SystemAdvancedSetting
{
    <#
    .EXAMPLE
        PS> Set-SystemAdvancedSetting -EndTask 'Disabled' -Sudo 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $EndTask,

        [state] $ModernRunDialog,

        [state] $LongPaths,

        [SudoMode] $Sudo
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
            'EndTask'         { Set-TaskbarEndTask -State $EndTask }
            'ModernRunDialog' { Set-ModernRunDialog -State $ModernRunDialog }
            'LongPaths'       { Set-LongPaths -State $LongPaths }
            'Sudo'            { Set-SudoCommand -Value $Sudo }
        }
    }
}
