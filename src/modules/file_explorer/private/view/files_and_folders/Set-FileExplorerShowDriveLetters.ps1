#=================================================================================================================
#                                    File Explorer - View > Show Drive Letters
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowDriveLetters
        [-Mode] {Disabled | AfterDriveName | BeforeDriveName}
        [<CommonParameters>]
#>

function Set-FileExplorerShowDriveLetters
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowDriveLetters -Mode 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [DriveLettersMode] $Mode
    )

    process
    {
        # AfterDriveName: 0 (default) | BeforeDriveName: 4 | off: 2

        $ShowDriveLetters = [HkcuExplorer]::new('ShowDriveLettersFirst', [int]$Mode, 'DWord')
        $ShowDriveLetters.WriteVerboseMsg('File Explorer - Show Drive Letters', $Mode)
        $ShowDriveLetters.SetRegistryEntry()
    }
}
