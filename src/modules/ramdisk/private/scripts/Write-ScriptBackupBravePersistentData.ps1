#=================================================================================================================
#                                   Write Script : Backup Brave Persistent Data
#=================================================================================================================

function Write-ScriptBackupBravePersistentData
{
    $FunctionsToWrite = @(
        'Get-LoggedOnUserUsername'
        'Get-LoggedOnUserSID'
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
