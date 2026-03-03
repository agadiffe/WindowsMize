#=================================================================================================================
#                                               Brave Browser Data
#=================================================================================================================

<#
  Brave write a lot of temp files in the 'User Data' directory.
  It seems that everything is written to these temp files and then written to the cache ?
  e.g.
  "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\random-file-name.tmp"
  "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\random-file-name.tmp"
#>

# Add the related directories/files if you are using a specific feature (e.g. history, cookies, top sites, ...).
# Persistent data will be saved on user logout and restored on user logon.

# The directory 'FilterListSubscriptionCache' doesn't work as symbolic link (make list update to fail).
# Some other files doesn't work as symbolic link: e.g. Local State, Bookmarks, Preferences, ...

<#
.SYNTAX
    Get-ProfilePathCombinations
        [-ProfileNames] <string[]>
        [-Path] <string[]>
        [<CommonParameters>]
#>

function Get-ProfilePathCombinations
{
    <#
    .EXAMPLE
        PS> Get-ProfilePathCombinations -ProfileNames 'Default', 'Profile 1' -Path 'Bookmarks', 'Favicons'
        Default\Bookmarks
        Default\Favicons
        Profile 1\Bookmarks
        Profile 1\Favicons
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string[]] $ProfileNames,

        [Parameter(Mandatory)]
        [string[]] $Path
    )

    process
    {
        $Data = @(
            foreach ($ProfileName in $ProfileNames)
            {
                foreach ($Item in $Path)
                {
                    "$ProfileName\$Item"
                }
            }
        )
        $Data
    }
}


<#
.SYNTAX
    Get-BraveDataException [<CommonParameters>]
#>

function Get-BraveDataException
{
    [CmdletBinding()]
    param ()

    process
    {
        $ProfileNames = (Get-BraveBrowserPathInfo)['ProfileNames']
        $CacheFolders = @{
            UserData = @(
                'component_crx_cache'
                'extensions_crx_cache'
                'GraphiteDawnCache'
                'GrShaderCache'
                'Safe Browsing'
                'ShaderCache'
            )
            ProfileData = Get-ProfilePathCombinations -ProfileNames $ProfileNames -Path @(
                'Cache'
                'Code Cache'
                'DawnGraphiteCache'
                'DawnWebGPUCache'
                'GPUCache'
            )
        }
        $SymlinkFolders = @{
            UserData = @()
            ProfileData = Get-ProfilePathCombinations -ProfileNames $ProfileNames -Path @(
                'DNR Extension Rules' # e.g. uBOL
                'Extensions'
                'Local Extension Settings'
            )
        }
        $PersistentData = @{
            UserData = @(
                'First Run'
                'Local State'
            )
            ProfileData = Get-ProfilePathCombinations -ProfileNames $ProfileNames -Path @(
                'FilterListSubscriptionCache\' # custom filter lists
                #'Network\Cookies'
                'Bookmarks'
                'Favicons'
                #'History'
                'Preferences'
                'Secure Preferences'
            )
        }

        $BraveDataException = @{
            Cache = @{
                Directory = $CacheFolders.Values.ForEach({ $_ })
            }
            Symlink = @{
                Directory = $SymlinkFolders.Values.ForEach({ $_ })
            }
            Persistent = $PersistentData.Values.ForEach({ $_ })
        }
        $BraveDataException
    }
}


<#
.SYNTAX
    Get-BraveCacheFoldersToSymlink
        [-RamDiskPath] <string>
        [<CommonParameters>]
#>

function Get-BraveCacheFoldersToSymlink
{
    <#
    .EXAMPLE
        PS> Get-BraveCacheFoldersToSymlink -RamDiskPath 'X:'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $RamDiskPath
    )

    process
    {
        $BravePathInfo = Get-BraveBrowserPathInfo
        $BraveDataToSymlink = @{
            BraveCache = @{
                LinkPath = "$($BravePathInfo['LocalAppData'])\User Data"
                TargetPath = "$RamDiskPath\Brave-Browser\User Data"
                Data = @{
                    Directory = (Get-BraveDataException)['Cache']['Directory']
                }
            }
        }
        $BraveDataToSymlink
    }
}


<#
.SYNTAX
    Get-BraveDataToSymlink
        [-RamDiskPath] <string>
        [<CommonParameters>]
#>

function Get-BraveDataToSymlink
{
    <#
    .EXAMPLE
        PS> Get-BraveDataToSymlink -RamDiskPath 'X:'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $RamDiskPath
    )

    process
    {
        $BravePathInfo = Get-BraveBrowserPathInfo
        $BraveDataToSymlink = [ordered]@{
            Brave = @{
                LinkPath = $BravePathInfo['LocalAppData']
                TargetPath = "$RamDiskPath\Brave-Browser"
                Data = @{
                    Directory = @(
                        'User Data'
                    )
                }
            }
            BraveException = @{
                LinkPath = "$RamDiskPath\Brave-Browser\User Data"
                TargetPath = $BravePathInfo['PersistentData']
                Data = @{
                    Directory = (Get-BraveDataException)['Symlink']['Directory']
                }
            }
        }
        $BraveDataToSymlink
    }
}
