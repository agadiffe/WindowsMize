#=================================================================================================================
#                                Bluetooth & Devices > AutoPlay > Removable Drive
#=================================================================================================================

<#
.SYNTAX
    Set-AutoPlayRemovableDrive
        [-Value] {Default | NoAction | OpenFolder | AskEveryTime}
        [<CommonParameters>]
#>

function Set-AutoPlayRemovableDrive
{
    <#
    .EXAMPLE
        PS> Set-AutoPlayRemovableDrive -Value 'OpenFolder'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [AutoPlayMode] $Value
    )

    process
    {
        $SettingValue = switch ($Value)
        {
            'NoAction'     { 'MSTakeNoAction' }
            'OpenFolder'   { 'MSOpenFolder' }
            'AskEveryTime' { 'MSPromptEachTime' }
        }

        $IsDefault = $Value -eq 'Default'

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

        Write-Verbose -Message "Setting 'AutoPlay Default - Removable Drive' to '$Value' ..."
        $AutoPlayRemovableDrive | Set-RegistryEntry
    }
}
