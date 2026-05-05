#=================================================================================================================
#                                            System > Share - Settings
#=================================================================================================================

# For GPO see: tweaks > Set-WindowsSharedExperience.

<#
.SYNTAX
    Set-ShareSetting
        [-NearbySharing {Disabled | DevicesOnly | EveryoneNearby}]
        [-FileSaveLocation <string>]
        [-ShowSuggestedApps {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-ShareSetting
{
    <#
    .EXAMPLE
        PS> Set-ShareSetting -NearbySharing 'Disabled' -FileSaveLocation 'X:\SharedFiles'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [NearShareMode] $NearbySharing,

        [ValidateScript(
            {
                $Item = Get-Item -Path $_ -ErrorAction 'SilentlyContinue'
                $Item.PSProvider.Name -eq 'FileSystem' -and $Item.PSIsContainer
            },
            ErrorMessage = 'The specified path is invalid. It must be an existing directory on a file system.')]
        [string] $FileSaveLocation,

        [state] $ShowSuggestedApps
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
            'NearbySharing'     { Set-NearbySharing -State $NearbySharing }
            'FileSaveLocation'  { Set-NearbySharingFileSaveLocation -Path $FileSaveLocation }
            'ShowSuggestedApps' { Set-ShareShowSuggestedApps -State $ShowSuggestedApps }
        }
    }
}
