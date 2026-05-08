#=================================================================================================================
#                          File Explorer - General > Single/Double-Click To Open An Item
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerOpenItem
        [-ClickMode] {SingleClick | DoubleClick}
        [<CommonParameters>]
#>

function Set-FileExplorerOpenItem
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerOpenItem -ClickMode 'DoubleClick'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [OpenItemMode] $ClickMode
    )

    process
    {
        # 5th byte, 6th bit\ single-click to open an item: 0 | double-click to open an item: 1 (default)

        $SettingRegPath = 'Software\Microsoft\Windows\CurrentVersion\Explorer'
        $SettingBytes = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name 'ShellState'
        Set-ByteBitFlag -Bytes $SettingBytes -ByteNum 4 -BitPos 6 -State ($ClickMode -eq 'DoubleClick')

        $OpenItem = [HkcuExplorer]::new('ShellState', $SettingBytes, 'Binary')
        $OpenItem.WriteVerboseMsg('File Explorer - Single/Double-Click To Open An Item', $ClickMode)
        $OpenItem.SetRegistryEntry()
    }
}
