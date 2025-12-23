#=================================================================================================================
#                                        System > AI Components - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-AIComponentsSetting
        [-AgenticFeatures {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-AIComponentsSetting
{
    <#
    .EXAMPLE
        PS> Set-AIComponentsSetting -AgenticFeatures 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $AgenticFeatures
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
            'AgenticFeatures' { Set-AIAgenticFeatures -State $AgenticFeatures }
        }
    }
}
