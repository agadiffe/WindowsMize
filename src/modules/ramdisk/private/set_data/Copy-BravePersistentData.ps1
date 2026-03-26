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
        $Path, $Destination = if ($Action -eq 'Backup') { 'UserData', 'PersistentData' } else { 'PersistentData', 'UserData' }
        $BraveBrowserPathInfo = Get-BraveBrowserPathInfo

        $BravePersistentData = @{
            Name        = (Get-BraveDataException)['Persistent']
            Path        = $BraveBrowserPathInfo[$Path]
            Destination = $BraveBrowserPathInfo[$Destination]
        }

        if ($Action -eq 'Backup')
        {
            # When a "custom filter lists" is removed from Brave, its associated file is removed.
            # Clean up the "Filter List Path" of the persistent folder before backing up the new data.
            $FilterListPath = $BravePersistentData['Name'] | Where-Object -FilterScript { $_ -like '*\FilterListSubscriptionCache*' }
            Remove-Item -Recurse -Path $FilterListPath.ForEach{( "$($BravePersistentData['Destination'])\$_" )} -ErrorAction 'SilentlyContinue'
        }

        Copy-Data @BravePersistentData
    }
}
