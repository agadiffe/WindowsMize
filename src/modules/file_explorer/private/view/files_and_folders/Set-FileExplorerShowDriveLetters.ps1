#=================================================================================================================
#                                    File Explorer - View > Show Drive Letters
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowDriveLetters
        [-State] {Disabled | AfterDriveName | BeforeDriveName}
        [<CommonParameters>]
#>

function Set-FileExplorerShowDriveLetters
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowDriveLetters -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [DriveLettersMode] $State
    )

    process
    {
        # AfterDriveName: 0 (default) | BeforeDriveName: 4 | off: 2

        $ShowDriveLetters = [HkcuExplorer]::new('ShowDriveLettersFirst', [int]$State, 'DWord')
        $ShowDriveLetters.WriteVerboseMsg('File Explorer - Show Drive Letters', $State)
        $ShowDriveLetters.SetRegistryEntry()
    }
}
