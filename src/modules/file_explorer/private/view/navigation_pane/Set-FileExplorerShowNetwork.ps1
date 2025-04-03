#=================================================================================================================
#                                       File Explorer - View > Show Network
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowNetwork
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowNetwork
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowNetwork -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # 5th byte\ on: 3rd bit 1, 4th bit 0 (default) | off: 3rd bit 0, 4th bit 1

        $SettingRegPath = 'Registry::HKEY_CURRENT_USER\Software\Classes\NotificationData'
        $SettingBytes = (Get-ItemProperty -Path $SettingRegPath).'0D83063EA3B8ACF5'

        if (-not $SettingBytes)
        {
            $SettingBytes = [byte[]]::new(8)
            $SettingBytes[0] = 1 # counter can't be 0 for the setting to be applied
        }

        Set-ByteBitFlag -Bytes $SettingBytes -ByteNum 4 -BitPos 3 -State ($State -eq 'Enabled')
        Set-ByteBitFlag -Bytes $SettingBytes -ByteNum 4 -BitPos 4 -State ($State -eq 'Disabled')

        $ShowNetwork = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Classes\NotificationData'
            Entries = @(
                @{
                    Name  = '0D83063EA3B8ACF5'
                    Value = $SettingBytes
                    Type  = 'Binary'
                }
            )
        }

        Write-Verbose -Message "Setting 'File Explorer - Show Network' to '$State' ..."
        Set-RegistryEntry -InputObject $ShowNetwork
    }
}
