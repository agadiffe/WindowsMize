#=================================================================================================================
#                                   System > Storage > Storage Sense - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-StorageSenseSetting
        [-StorageSense {Disabled | Enabled}]
        [-StorageSenseGPO {Disabled | Enabled | NotConfigured}]
        [-CleanupTempFiles {Disabled | Enabled}]
        [-CleanupTempFilesGPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-StorageSenseSetting
{
    <#
    .EXAMPLE
        PS> Set-StorageSenseSetting -StorageSense 'Disabled' -StorageSenseGPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $StorageSense,

        [GpoState] $StorageSenseGPO,

        [state] $CleanupTempFiles,

        [GpoState] $CleanupTempFilesGPO
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
            'StorageSense'        { Set-StorageSense -State $StorageSense }
            'StorageSenseGPO'     { Set-StorageSense -GPO $StorageSenseGPO }
            'CleanupTempFiles'    { Set-StorageSenseCleanupTempFiles -State $CleanupTempFiles }
            'CleanupTempFilesGPO' { Set-StorageSenseCleanupTempFiles -GPO $CleanupTempFilesGPO }
        }
    }
}
