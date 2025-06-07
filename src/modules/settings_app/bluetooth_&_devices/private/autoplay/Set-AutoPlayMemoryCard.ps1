#=================================================================================================================
#                                  Bluetooth & Devices > AutoPlay > Memory Card
#=================================================================================================================

<#
.SYNTAX
    Set-AutoPlayMemoryCard
        [-Value] {Default | NoAction | OpenFolder | AskEveryTime}
        [<CommonParameters>]
#>

function Set-AutoPlayMemoryCard
{
    <#
    .EXAMPLE
        PS> Set-AutoPlayMemoryCard -Value 'OpenFolder'
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
        $AutoPlayMemoryCard = @(
            @{
                RemoveKey = $IsDefault
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\CameraAlternate\ShowPicturesOnArrival'
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
                Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\CameraAlternate\ShowPicturesOnArrival'
                Entries = @(
                    @{
                        Name  = '(Default)'
                        Value = $SettingValue
                        Type  = 'String'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'AutoPlay Default - Memory Card' to '$Value' ..."
        $AutoPlayMemoryCard | Set-RegistryEntry
    }
}
