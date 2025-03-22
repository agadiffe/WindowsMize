#=================================================================================================================
#                                    Bluetooth & Devices > AutoPlay - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-AutoPlaySetting
        [-AutoPlay {Disabled | Enabled}]
        [-AutoPlayGPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AutoPlaySetting
{
    <#
    .EXAMPLE
        PS> Set-AutoPlaySetting -AutoPlay 'Disabled' -AutoPlayGPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $AutoPlay,

        [GpoStateWithoutEnabled] $AutoPlayGPO
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
            'AutoPlay'    { Set-AutoPlay -State $AutoPlay }
            'AutoPlayGPO' { Set-AutoPlay -GPO $AutoPlayGPO }
        }
    }
}
