#=================================================================================================================
#                                             Visual Studio Code Data
#=================================================================================================================

function Get-VSCodeUserDataPath
{
    "$((Get-LoggedOnUserEnvVariable).APPDATA)\Code"
}

function Get-VSCodeDataToRamDisk
{
    $VSCodeUserFolders = @(
        'User\globalStorage\ms-vscode.powershell' # powershell extension
    )

    $VSCodeDirectoryExcluded = @(
        'User'
    )
    $VSCodeFoldersParam = @{
        Path      = Get-VSCodeUserDataPath
        Directory = $true
        Name      = $true
        Exclude   = $VSCodeDirectoryExcluded
    }
    $VSCodeFolders = Get-ChildItem @VSCodeFoldersParam

    $VSCodeDataToRamDisk = @{
        Directory = @(
            $VSCodeFolders
            $VSCodeUserFolders
        )
    }
    $VSCodeDataToRamDisk
}


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
                LinkPath = Get-VSCodeUserDataPath
                TargetPath = "$RamDiskPath\VSCode"
                Data = @{
                    Directory = (Get-VSCodeDataToRamDisk).Directory
                }
            }
        }
        $VSCodeDataToSymlink
    }
}
