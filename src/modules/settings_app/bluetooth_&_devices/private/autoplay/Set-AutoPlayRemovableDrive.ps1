#=================================================================================================================
#                                Bluetooth & Devices > AutoPlay > Removable Drive
#=================================================================================================================

<#
.SYNTAX
    Set-AutoPlayRemovableDrive
        [-Action] {Default | NoAction | OpenFolder | AskEveryTime}
        [<CommonParameters>]
#>

function Set-AutoPlayRemovableDrive
{
    <#
    .EXAMPLE
        PS> Set-AutoPlayRemovableDrive -Action 'OpenFolder'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [AutoPlayMode] $Action
    )

    process
    {
        $SettingValue = switch ($Action)
        {
            'NoAction'     { 'MSTakeNoAction' }
            'OpenFolder'   { 'MSOpenFolder' }
            'AskEveryTime' { 'MSPromptEachTime' }
        }

        $IsDefault = $Action -eq 'Default'

        # Default: delete key (default) | NoAction: MSTakeNoAction | OpenFolder: MSOpenFolder | AskEveryTime: MSPromptEachTime
        $AutoPlayRemovableDrive = @(
            @{
                RemoveKey = $IsDefault
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\StorageOnArrival'
                Entries = @(
                    @{
                        Name  = '(Default)'
                        Value = $SettingValue
                        Type  = 'String'
                    }
                )
            }
            @{
                RemoveKey = $IsDefault
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\StorageOnArrival'
                Entries = @(
                    @{
                        Name  = '(Default)'
                        Value = $SettingValue
                        Type  = 'String'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'AutoPlay Default - Removable Drive' to '$Action' ..."
        $AutoPlayRemovableDrive | Set-RegistryEntry
    }
}
