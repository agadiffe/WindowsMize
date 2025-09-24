#=================================================================================================================
#                                   Write Script : Backup Brave Persistent Data
#=================================================================================================================

<#
.SYNTAX
    Write-ScriptBackupBravePersistentData [<CommonParameters>]
#>

function Write-ScriptBackupBravePersistentData
{
    [CmdletBinding()]
    param ()

    process
    {
        $FunctionsToWrite = @(
            'Get-LoggedOnUserInfo'
            'Get-LoggedOnUserEnvVariable'
            'Get-BraveBrowserPathInfo'
            'Get-ProfilePathCombinations'
            'Get-BraveDataException'
            'Copy-Data'
            'Copy-BravePersistentData'
        )

        $RamDiskLogoffScriptContent = $FunctionsToWrite | Write-Function
        $RamDiskLogoffScriptContent += '
            Copy-BravePersistentData -Action ''Backup''
        ' -replace '(?m)^ *'
        $RamDiskLogoffScriptContent
    }
}
