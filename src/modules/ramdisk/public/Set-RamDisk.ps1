#=================================================================================================================
#                                    Set RamDisk : Scripts And Scheduled Tasks
#=================================================================================================================

<#
.SYNTAX
    Set-RamDisk
        -Size <string>
        -AppToRamDisk {Brave | BraveCache | VSCode}
        [<CommonParameters>]

    Set-RamDisk
        -RemoveCreationScript
        -RemoveUserScript
        [<CommonParameters>]
#>

function Set-RamDisk
{
    <#
    .EXAMPLE
        PS> Set-RamDisk -Size '1G' -AppToRamDisk 'BraveCache', 'VSCode'

    .EXAMPLE
        PS> Set-RamDisk -RemoveCreationScript -RemoveUserScript
    #>

    [CmdletBinding(DefaultParameterSetName = 'Create')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Create')]
        [ValidatePattern(
            '^\d+[MG]$',
            ErrorMessage = 'Size format must be a number followed by M or G. (e.g. ''512M'' or ''2G'').')]
        [string] $Size,

        [Parameter(Mandatory, ParameterSetName = 'Create')]
        [AppName[]] $AppToRamDisk,

        [Parameter(Mandatory, ParameterSetName = 'Remove')]
        [switch] $RemoveCreationScript,

        [Parameter(Mandatory, ParameterSetName = 'Remove')]
        [switch] $RemoveUserScript
    )

    process
    {
        if ($AppToRamDisk -contains [AppName]::Brave -and $AppToRamDisk -contains [AppName]::BraveCache)
        {
            Write-Error -Message 'Brave and BraveCache cannot be used together.'
            return
        }

        if ($AppToRamDisk -contains [AppName]::Brave -and -not (Get-Command -Name 'gpedit.msc' -ErrorAction 'SilentlyContinue'))
        {
            Write-Error -Message 'Brave option requires Group Policy feature (gpedit.msc). Use BraveCache instead.'
            return
        }

        $Username = (Get-LoggedOnUserInfo)['UserName']
        $RamDiskName = 'RamDisk'
        $RamDiskCreationTaskName = "$RamDiskName - Creation"
        $RamDiskSetDataTaskName = "$RamDiskName - Set Data ($Username)"
        $RamDiskBackupBraveDataTaskName = "$RamDiskName - Backup Brave Persistent Data ($Username)"

        $StartupScriptFilePath = "$env:SystemDrive\RamDisk script\create_ramdisk.ps1"
        $EnvLocalAppData = (Get-LoggedOnUserEnvVariable).LOCALAPPDATA
        $LogonScriptFilePath = "$EnvLocalAppData\set_data_to_ramdisk.ps1"
        $LogoffScriptFilePath = "$EnvLocalAppData\save_brave_files_to_persistent_path.ps1"

        if ($PSCmdlet.ParameterSetName -eq 'Create')
        {
            New-ScriptRamDiskCreation -FilePath $StartupScriptFilePath -Name $RamDiskName -Size $Size
            New-ScheduledTaskStartup -FilePath $StartupScriptFilePath -TaskName $RamDiskCreationTaskName

            $ScriptSetDataParam = @{
                FilePath        = $LogonScriptFilePath
                RamDiskName     = $RamDiskName
                RamDiskTaskName = $RamDiskCreationTaskName
                AppToRamDisk    = $AppToRamDisk
            }
            New-ScriptRamDiskSetData @ScriptSetDataParam
            New-ScheduledTaskUserLogon -User $Username -FilePath $LogonScriptFilePath -TaskName $RamDiskSetDataTaskName

            if ($AppToRamDisk.Contains([AppName]::Brave))
            {
                New-ScriptBackupBravePersistentData -FilePath $LogoffScriptFilePath
                New-UserGpoScriptLogoff -FilePath $LogoffScriptFilePath -VerboseMsg $RamDiskBackupBraveDataTaskName
            }
            else
            {
                Remove-Item -Path $LogoffScriptFilePath -ErrorAction 'SilentlyContinue'
                Remove-UserGpoScript -FilePath $LogoffScriptFilePath -Type 'Logoff'
                Set-DataToRamDisk -AppToRamDisk 'Brave' -Remove
                Remove-Item -Recurse -Path ((Get-BraveBrowserPathInfo)['PersistentData']) -ErrorAction 'SilentlyContinue'
            }

            'VSCode', 'BraveCache' | ForEach-Object -Process {
                if (-not $AppToRamDisk.Contains([AppName]::$_))
                {
                    Set-DataToRamDisk -AppToRamDisk $_ -Remove
                }
            }
        }
        else
        {
            if ($RemoveCreationScript)
            {
                Write-Verbose -Message 'Removing ''RamDisk Creation'' Script & Scheduled Task ...'

                Remove-Item -Path $StartupScriptFilePath -ErrorAction 'SilentlyContinue'
                Unregister-ScheduledTask -TaskPath '\' -TaskName $RamDiskCreationTaskName -Confirm:$false -ErrorAction 'SilentlyContinue'
            }

            if ($RemoveUserScript)
            {
                Write-Verbose -Message 'Removing ''RamDisk User'' Script & Scheduled Task ...'

                Remove-Item -Path $LogonScriptFilePath, $LogoffScriptFilePath -ErrorAction 'SilentlyContinue'
                Unregister-ScheduledTask -TaskPath '\' -TaskName $RamDiskSetDataTaskName -Confirm:$false -ErrorAction 'SilentlyContinue'
                Remove-UserGpoScript -FilePath $LogoffScriptFilePath -Type 'Logoff'

                # Delete all symlink & restore Brave symlinked folders + persistent data.
                Set-DataToRamDisk -AppToRamDisk 'Brave', 'BraveCache', 'VSCode' -Remove
                Remove-Item -Recurse -Path ((Get-BraveBrowserPathInfo)['PersistentData']) -ErrorAction 'SilentlyContinue'
            }
        }
    }
}
