#=================================================================================================================
#                                       System > For Developers - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-ForDevelopersSetting
        [-EndTask {Disabled | Enabled}]
        [-Sudo {Disabled | NewWindow | InputDisabled | Inline}]
        [<CommonParameters>]
#>

function Set-ForDevelopersSetting
{
    <#
    .EXAMPLE
        PS> Set-ForDevelopersSetting -EndTask 'Disabled' -Sudo 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $EndTask,

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
            'EndTask' { Set-TaskbarEndTask -State $EndTask }
            'Sudo'    { Set-SudoCommand -Value $Sudo }
        }
    }
}
