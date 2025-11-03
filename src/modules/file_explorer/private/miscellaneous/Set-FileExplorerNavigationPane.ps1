#=================================================================================================================
#                                     File Explorer - Misc > Navigation Pane
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerNavigationPane
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerNavigationPane
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerNavigationPane -Value 'SameWindow'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # 5th byte, 1rst bit\ on: 1 (default) | off: 0

        $SettingRegPath = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer'
        $SettingBytes = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name 'PageSpaceControlSizer'
        Set-ByteBitFlag -Bytes $SettingBytes -ByteNum 4 -BitPos 1 -State ($State -eq 'Enabled')

        $NavigationPane = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer'
            Entries = @(
                @{
                    Name  = 'PageSpaceControlSizer'
                    Value = $SettingBytes
                    Type  = 'Binary'
                }
            )
        }

        Write-Verbose -Message "Setting 'File Explorer - Navigation Pane' to '$State' ..."
        Set-RegistryEntry -InputObject $NavigationPane
    }
}
