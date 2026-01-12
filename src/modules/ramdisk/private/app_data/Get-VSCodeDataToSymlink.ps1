#=================================================================================================================
#                                             Visual Studio Code Data
#=================================================================================================================

<#
.SYNTAX
    Get-VSCodeDataToSymlink
        [-RamDiskPath] <string>
        [<CommonParameters>]
#>

function Get-VSCodeDataToSymlink
{
    <#
    .EXAMPLE
        PS> Get-VSCodeDataToSymlink -RamDiskPath 'X:'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $RamDiskPath
    )

    process
    {
        $VSCodeDataToSymlink = @{
            VSCode = @{
                LinkPath = "$((Get-LoggedOnUserEnvVariable).APPDATA)\Code"
                TargetPath = "$RamDiskPath\VSCode"
                Data = @{
                    Directory = @(
                        'User\globalStorage\ms-vscode.powershell' # powershell extension
                        'Backups' # unsaved files. Comment if you want to keep this feature across computer restart.
                        'blob_storage'
                        'Cache'
                        'CachedData'
                        'CachedProfilesData'
                        'Code Cache'
                        'DawnGraphiteCache'
                        'DawnWebGPUCache'
                        'Dictionaries'
                        'GPUCache'
                        'Local Storage'
                        'logs'
                        'Network'
                        'Session Storage'
                        'Shared Dictionary'
                        'WebStorage'
                    )
                }
            }
        }
        $VSCodeDataToSymlink
    }
}
