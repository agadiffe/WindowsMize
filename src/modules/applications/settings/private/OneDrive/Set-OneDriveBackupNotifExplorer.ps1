#=================================================================================================================
#                                       Set OneDrive Backup Notif Explorer
#=================================================================================================================

<#
.SYNTAX
    Set-OneDriveBackupNotifExplorer
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-OneDriveBackupNotifExplorer
{
    <#
    .EXAMPLE
        PS> Set-OneDriveBackupNotifExplorer -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $FolderGuid = @{
            Desktop   = '{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}'
            Documents = '{FDD39AD0-238F-46AF-ADB4-6C85480369C7}'
            Music     = '{4BD8D571-6D19-48D3-BE97-422220080E43}'
            Pictures  = '{33E28130-4E1E-4676-835A-98395C3BC3BB}'
            Videos    = '{18989B1D-99B5-455B-841C-AB7C74E4DDFC}'
        }

        foreach ($Item in $FolderGuid.GetEnumerator())
        {
            # on: delete key (default) | off: 1 -2
            $OneDriveBackupNotifExplorer = @{
                RemoveKey = $State -eq 'Enabled'
                Hive    = 'HKEY_CURRENT_USER'
                Path    = "Software\Microsoft\Windows\CurrentVersion\Explorer\Backup\$($Item.Value)"
                Entries = @(
                    @{
                        Name  = 'TurnOffReminder'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'VisitedTimestamps' # tip popup (after 3 timestamps -> -1 or -2)
                        Value = '-2'
                        Type  = 'String'
                    }
                )
            }

            Write-Verbose -Message "Setting 'OneDrive Backup Notif - Explorer  ($($Item.Key))' to '$State' ..."
            Set-RegistryEntry -InputObject $OneDriveBackupNotifExplorer
        }
    }
}
