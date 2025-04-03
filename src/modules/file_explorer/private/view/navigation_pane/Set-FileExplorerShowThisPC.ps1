#=================================================================================================================
#                                       File Explorer - View > Show This PC
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowThisPC
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowThisPC
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowThisPC -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # 5th byte\ on: 1st bit 1, 2nd bit 0 (default) | off: 1st bit 0, 2nd bit 1

        $SettingRegPath = 'Registry::HKEY_CURRENT_USER\Software\Classes\NotificationData'
        $SettingBytes = (Get-ItemProperty -Path $SettingRegPath).'0D83063EA3B8ACF5'

        if (-not $SettingBytes)
        {
            $SettingBytes = [byte[]]::new(8)
            $SettingBytes[0] = 1 # counter can't be 0 for the setting to be applied
        }

        Set-ByteBitFlag -Bytes $SettingBytes -ByteNum 4 -BitPos 1 -State ($State -eq 'Enabled')
        Set-ByteBitFlag -Bytes $SettingBytes -ByteNum 4 -BitPos 2 -State ($State -eq 'Disabled')

        $ShowThisPC = @{
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

        Write-Verbose -Message "Setting 'File Explorer - Show This PC' to '$State' ..."
        Set-RegistryEntry -InputObject $ShowThisPC
    }
}
