#=================================================================================================================
#                                      System > Display - Graphics Settings
#=================================================================================================================

<#
.SYNTAX
    Set-DisplayGraphicsSetting
        [-AutoHDR {Disabled | Enabled}]
        [-GamesVariableRefreshRate {Disabled | Enabled}]
        [-GPUScheduling {Disabled | Enabled}]
        [-WindowedGamesOptimizations {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-DisplayGraphicsSetting
{
    <#
    .EXAMPLE
        PS> Set-DisplayGraphicsSetting -GamesVariableRefreshRate 'Disabled' -WindowedGamesOptimizations 'Enabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $AutoHDR,

        [state] $GamesVariableRefreshRate,

        [state] $GPUScheduling,

        [state] $WindowedGamesOptimizations
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
            'AutoHDR'
            {
                if ($AutoHDR -eq 'Enabled')
                {
                    Set-DisplayGraphics -Name 'WindowedGamesOptimizations' -State 'Enabled'
                }
                Set-DisplayGraphics -Name 'AutoHDR' -State $AutoHDR
            }
            'GamesVariableRefreshRate'
            {
                Set-DisplayGraphics -Name 'GamesVariableRefreshRate' -State $GamesVariableRefreshRate
            }
            'GPUScheduling'
            {
                Set-DisplayGraphicsGpuScheduling -State $GPUScheduling
            }
            'WindowedGamesOptimizations'
            {
                if ($WindowedGamesOptimizations -eq 'Disabled')
                {
                    Set-DisplayGraphics -Name 'AutoHDR' -State 'Disabled'
                }
                Set-DisplayGraphics -Name 'WindowedGamesOptimizations' -State $WindowedGamesOptimizations
            }
        }
    }
}
