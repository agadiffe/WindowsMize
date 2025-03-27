#=================================================================================================================
#                                               Brave Browser Data
#=================================================================================================================

# Add the related directories/files if you are using a specific feature (e.g. history, cookies, top sites, ...).
# Persistent data will be saved on user logout and restored on user logon.

# The directory 'FilterListSubscriptionCache' doesn't work as symbolic link (make list update to fail).
# Some other files doesn't work as symbolic link: e.g. Local State, Bookmarks, Preferences, ...

<#
.SYNTAX
    Get-ProfilePathCombinations
        [-ProfilesNames] <string[]>
        [-Path] <string[]>
        [<CommonParameters>]
#>

function Get-ProfilePathCombinations
{
    <#
    .EXAMPLE
        PS> Get-ProfilePathCombinations -ProfilesNames 'Default', 'Profile 1' -Path 'Bookmarks', 'Favicons'
        Default\Bookmarks
        Default\Favicons
        Profile 1\Bookmarks
        Profile 1\Favicons
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string[]] $ProfilesNames,
        
        [Parameter(Mandatory)]
        [string[]] $Path
    )

    $Data = @(
        foreach ($Profile in $ProfilesNames)
        {
            foreach ($Item in $Path)
            {
                "$Profile\$Item"
            }
        }
    )
    $Data
}


function Get-BraveDataException
{
    $ProfilesNames = (Get-BraveBrowserPathInfo).ProfilesNames
    $SymlinkFolders = @{
        UserData = @()
        ProfileData = Get-ProfilePathCombinations -ProfilesNames $ProfilesNames -Path @(
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
        ProfileData = Get-ProfilePathCombinations -ProfilesNames $ProfilesNames -Path @(
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
        Symlink = @{
            Directory = $SymlinkFolders.Values.ForEach({ $_ })
        }
        Persistent = $PersistentData.Values.ForEach({ $_ })
    }
    $BraveDataException
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
        $BraveDataToSymlink = @{
            Brave = @{
                LinkPath = (Get-BraveBrowserPathInfo).LocalAppData
                TargetPath = "$RamDiskPath\Brave-Browser"
                Data = @{
                    Directory = @(
                        'User Data'
                    )
                }
            }
            BraveException = @{
                LinkPath = "$RamDiskPath\Brave-Browser\User Data"
                TargetPath = (Get-BraveBrowserPathInfo).PersistentData
                Data = @{
                    Directory = (Get-BraveDataException).Symlink.Directory
                }
            }
        }
        $BraveDataToSymlink
    }
}
