#=================================================================================================================
#                                       System > Nearby Sharing - Settings
#=================================================================================================================

# For GPO see: tweaks > Set-WindowsSharedExperience.

<#
.SYNTAX
    Set-NearbySharingSetting
        [-NearbySharing {Disabled | DevicesOnly | EveryoneNearby}]
        [-FileSaveLocation <string>]
        [<CommonParameters>]
#>

function Set-NearbySharingSetting
{
    <#
    .EXAMPLE
        PS> Set-NearbySharingSetting -NearbySharing 'Disabled' -FileSaveLocation 'X:\SharedFiles'
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
        [string] $FileSaveLocation
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
            'NearbySharing'    { Set-NearbySharing -State $NearbySharing }
            'FileSaveLocation' { Set-NearbySharingFileSaveLocation -Path $FileSaveLocation }
        }
    }
}
