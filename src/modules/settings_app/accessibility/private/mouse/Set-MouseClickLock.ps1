#=================================================================================================================
#                                       Accessibility > Mouse > Click Lock
#=================================================================================================================

<#
.SYNTAX
    Set-MouseClickLock
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MouseClickLock
{
    <#
    .EXAMPLE
        PS> Set-MouseClickLock -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # 2nd byte, 8th bit\ on: 1 | off: 0 (default)

        $SettingRegPath = 'Control Panel\Desktop'
        $SettingBytes = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name 'UserPreferencesMask'
        Set-ByteBitFlag -Bytes $SettingBytes -ByteNum 1 -BitPos 8 -State ($State -eq 'Enabled')

        $MouseClickLock = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Desktop'
            Entries = @(
                @{
                    Name  = 'UserPreferencesMask'
                    Value = $SettingBytes
                    Type  = 'Binary'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Click Lock' to '$State' ..."
        Set-RegistryEntry -InputObject $MouseClickLock
    }
}
