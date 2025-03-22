#=================================================================================================================
#                                           Copy Brave Persistent Data
#=================================================================================================================

<#
.SYNTAX
    Copy-BravePersistentData
        [-Action] {Backup | Restore}
        [<CommonParameters>]
#>

function Copy-BravePersistentData
{
    <#
    .EXAMPLE
        PS> Copy-BravePersistentData -Action 'Backup'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Backup', 'Restore')]
        [string] $Action
    )

    process
    {
        $IsBackupAction = $Action -eq 'Backup'
        $Path = $IsBackupAction ? 'UserData' : 'PersistentData'
        $Destination = $IsBackupAction ? 'PersistentData' : 'UserData'

        $BravePersistentData = @{
            Name        = (Get-BraveDataException).Persistent
            Path        = (Get-BraveBrowserPathInfo).$Path
            Destination = (Get-BraveBrowserPathInfo).$Destination
        }
        Copy-Data @BravePersistentData
    }
}
