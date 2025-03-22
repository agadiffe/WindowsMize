#=================================================================================================================
#                                               Brave Browser Data
#=================================================================================================================

# Add the related directories/files if you are using a specific feature (e.g. history, cookies, top sites, ...).
# Persistent data will be saved on user logout and restored on user logon.

# The directory 'FilterListSubscriptionCache' doesn't work as symbolic link (make list update to fail).
# Some other files doesn't work as symbolic link: e.g. Local State, Bookmarks, Preferences, ...

function Get-BraveDataException
{
    $BraveProfileName = Split-Path -Path (Get-BraveBrowserPathInfo).Profile -Leaf

    $BraveDataException = @{
        Symlink = @{
            Directory = @(
                "$BraveProfileName\DNR Extension Rules" # e.g. uBOL
                "$BraveProfileName\Extensions"
                "$BraveProfileName\Local Extension Settings"
            )
        }
        Persistent = @(
            "First Run"
            "Local State"
            "$BraveProfileName\FilterListSubscriptionCache\" # custom filter lists
            #"$BraveProfileName\Network\Cookies"
            "$BraveProfileName\Bookmarks"
            "$BraveProfileName\Favicons"
            #"$BraveProfileName\History"
            "$BraveProfileName\Preferences"
            "$BraveProfileName\Secure Preferences"
        )
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
