#=================================================================================================================
#                          File Explorer - General > Open Each Folder In Same/New Window
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerOpenFolder
        [-Value] {SameWindow | NewWindow}
        [<CommonParameters>]
#>

function Set-FileExplorerOpenFolder
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerOpenFolder -Value 'SameWindow'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [OpenFolderMode] $Value
    )

    process
    {
        # 5th byte, 6th bit\ open each folder in the same window: 0 (default) | open each folder in its own window: 1

        $SettingRegPath = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState'
        $SettingBytes = Get-ItemPropertyValue -Path $SettingRegPath -Name 'Settings'
        Set-ByteBitFlag -Bytes $SettingBytes -ByteNum 4 -BitPos 6 -State ($Value -eq 'NewWindow')

        $OpenFolder = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState'
            Entries = @(
                @{
                    Name  = 'Settings'
                    Value = $SettingBytes
                    Type  = 'Binary'
                }
            )
        }

        Write-Verbose -Message "Setting 'File Explorer - Open Each Folder In Same/New Window' to '$Value' ..."
        Set-RegistryEntry -InputObject $OpenFolder
    }
}
