#=================================================================================================================
#                                           Copy Brave Data For Symlink
#=================================================================================================================

<#
.SYNTAX
    Copy-BraveDataForSymlink
        [-Name] <string[]>
        [-Action] {Backup | Restore}
        [<CommonParameters>]
#>

function Copy-BraveDataForSymlink
{
    <#
    .DESCRIPTION
        Copies Brave data to the persistent folder in preparation for replacing it with a symlink.
        Copies the data if not a symlink and not in persistent folder.

    .EXAMPLE
        PS> Copy-BraveDataForSymlink -Name 'Default\Extensions', 'Default\Local Extension Settings' -Action 'Backup'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string[]] $Name,

        [Parameter(Mandatory)]
        [ValidateSet('Backup', 'Restore')]
        [string] $Action
    )

    process
    {
        $IsBackupAction = $Action -eq 'Backup'
        $Path = $IsBackupAction ? 'UserData' : 'PersistentData'
        $Destination = $IsBackupAction ? 'PersistentData' : 'UserData'

        $ItemToCopy = @(
            foreach ($Item in $Name)
            {
                $GetItemParam = @{
                    Path        = "$((Get-BraveBrowserPathInfo).$Path)\$Item"
                    ErrorAction = 'SilentlyContinue'
                }
                $LinkTarget = (Get-Item @GetItemParam).LinkTarget # null if not a Link
                if (-not $LinkTarget -and -not (Test-Path -Path "$((Get-BraveBrowserPathInfo).$Destination)\$Item"))
                {
                    $Item
                }
            }
        )

        $BraveDataForSymlink = @{
            Name        = $ItemToCopy
            Path        = (Get-BraveBrowserPathInfo).$Path
            Destination = (Get-BraveBrowserPathInfo).$Destination
        }
        Copy-Data @BraveDataForSymlink
    }
}
