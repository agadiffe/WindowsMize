#=================================================================================================================
#                                          Set RamDisk Scripts And Tasks
#=================================================================================================================

<#
.SYNTAX
    Set-RamDisk
        [-AppToRamDisk] {Brave | VSCode}
        [<CommonParameters>]
#>

function Set-RamDisk
{
    <#
    .EXAMPLE
        PS> Set-RamDisk -AppToRamDisk 'Brave', 'VSCode'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [AppName[]] $AppToRamDisk
    )

    process
    {
        $RamDiskName = 'RamDisk'
        $RamDiskCreationTaskName = 'RamDisk - Creation'

        $StartupScriptFilePath = "$env:SystemDrive\RamDisk script\create_ramdisk.ps1"
        $LogonScriptFilePath = "$((Get-LoggedOnUserEnvVariable).LOCALAPPDATA)\set_data_to_ramdisk.ps1"
        $LogoffScriptFilePath = "$((Get-LoggedOnUserEnvVariable).LOCALAPPDATA)\save_brave_files_to_persistent_path.ps1"

        New-ScriptRamDiskCreation -FilePath $StartupScriptFilePath -RamDiskName $RamDiskName
        New-ScheduledTaskRamDiskCreation -FilePath $StartupScriptFilePath -TaskName $RamDiskCreationTaskName

        $ScriptSetDataParam = @{
            FilePath        = $LogonScriptFilePath
            RamDiskName     = $RamDiskName
            RamDiskTaskName = $RamDiskCreationTaskName
            AppToRamDisk    = $AppToRamDisk
        }
        New-ScriptRamDiskSetData @ScriptSetDataParam
        New-ScheduledTaskRamDiskSetData -FilePath $LogonScriptFilePath

        if ($AppToRamDisk.Contains([AppName]::Brave))
        {
            New-ScriptBackupBravePersistentData -FilePath $LogoffScriptFilePath
            New-GPOScriptBackupBravePersistentData -FilePath $LogoffScriptFilePath
        }
    }
}
