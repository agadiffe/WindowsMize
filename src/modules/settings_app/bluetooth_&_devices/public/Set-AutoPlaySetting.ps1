#=================================================================================================================
#                                    Bluetooth & Devices > AutoPlay - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-AutoPlaySetting
        [-AutoPlay {Disabled | Enabled}]
        [-AutoPlayGPO {Disabled | NotConfigured}]
        [-RemovableDrive {Default | NoAction | OpenFolder | AskEveryTime}]
        [-MemoryCard {Default | NoAction | OpenFolder | AskEveryTime}]
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

        [GpoStateWithoutEnabled] $AutoPlayGPO,

        [AutoPlayMode] $RemovableDrive,

        [AutoPlayMode] $MemoryCard
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
            'AutoPlay'       { Set-AutoPlay -State $AutoPlay }
            'AutoPlayGPO'    { Set-AutoPlay -GPO $AutoPlayGPO }
            'RemovableDrive' { Set-AutoPlayRemovableDrive -Value $RemovableDrive }
            'MemoryCard'     { Set-AutoPlayMemoryCard -Value $MemoryCard }
        }
    }
}
