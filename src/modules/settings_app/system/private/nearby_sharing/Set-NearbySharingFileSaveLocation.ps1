#=================================================================================================================
#                                System > Nearby Sharing > Save Files I Receive To
#=================================================================================================================

<#
.SYNTAX
    Set-NearbySharingFileSaveLocation
        [-Path] <string>
        [<CommonParameters>]
#>

function Set-NearbySharingFileSaveLocation
{
    <#
    .EXAMPLE
        PS> Set-NearbySharingFileSaveLocation -Path 'X:\SharedFiles'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateScript(
            {
                $Item = Get-Item -Path $_ -ErrorAction 'SilentlyContinue'
                $Item.PSProvider.Name -eq 'FileSystem' -and $Item.PSIsContainer
            },
            ErrorMessage = 'The specified path is invalid. It must be an existing directory on a file system.')]
        [string] $Path
    )

    process
    {
        # default location: Downloads folder
        $NearbySharingFileSaveLocation = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\CDP'
            Entries = @(
                @{
                    Name  = 'NearShareFileSaveLocation'
                    Value = $Path
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Nearby Sharing - Save Files I Receive To' to '$Path' ..."
        Set-RegistryEntry -InputObject $NearbySharingFileSaveLocation
    }
}
