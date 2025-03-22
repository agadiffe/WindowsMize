#=================================================================================================================
#                 Personnalization > Taskbar > Taskbar Behaviors > Automatically Hide The Taskbar
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarAutoHide
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarAutoHide
{
    <#
    .EXAMPLE
        PS> Set-TaskbarAutoHide -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # 9th byte, first bit\ on: 1 | off: 0 (default)
        $SettingRegPath = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
        $SettingBytes = Get-ItemPropertyValue -Path $SettingRegPath -Name 'Settings'
        Set-ByteBitFlag -Bytes $SettingBytes -ByteNum 8 -BitPos 1 -State ($State -eq 'Enabled')

        $TaskbarAutoHide = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
            Entries = @(
                @{
                    Name  = 'Settings'
                    Value = $SettingBytes
                    Type  = 'Binary'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar - Automatically Hide The Taskbar' to '$State' ..."
        Set-RegistryEntry -InputObject $TaskbarAutoHide
    }
}
