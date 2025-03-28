#=================================================================================================================
#                                         Write Script : RamDisk Set Data
#=================================================================================================================

<#
.SYNTAX
    Write-ScriptRamDiskSetData
        [-RamDiskName] <string>
        [-RamDiskTaskName] <string>
        [-AppToRamDisk] {Brave | VSCode}
        [<CommonParameters>]
#>

function Write-ScriptRamDiskSetData
{
    <#
    .EXAMPLE
        PS> Write-ScriptRamDiskSetData -RamDiskName 'RamDisk' -RamDiskTaskName 'MyTaskName' -AppToRamDisk 'Brave'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $RamDiskName,

        [Parameter(Mandatory)]
        [string] $RamDiskTaskName,

        [Parameter(Mandatory)]
        [AppName[]] $AppToRamDisk
    )

    process
    {
        $RamDiskSetDataScriptContent = Get-Content -Path "$PSScriptRoot\..\..\classes\Enums.ps1"
        $FunctionsToWrite = @(
            'Get-LoggedOnUserUsername'
            'Get-LoggedOnUserSID'
            'Get-LoggedOnUserEnvVariable'
            'Get-BraveBrowserPathInfo'
            'Get-ProfilePathCombinations'
            'Get-BraveDataException'
            'Get-BraveDataToSymlink'
            'Get-VSCodeUserDataPath'
            'Get-VSCodeDataToRamDisk'
            'Get-VSCodeDataToSymlink'
            'Get-DataToSymlink'
            'New-ParentPath'
            'New-SymbolicLink'
            'New-SymbolicLinksPair'
            'Remove-SymbolicLink'
            'Copy-Data'
            'Copy-BravePersistentData'
            'New-RamDiskUserProfile'
            'Get-DrivePath'
            'Set-DataToRamDisk'
        )
        $RamDiskSetDataScriptContent += $FunctionsToWrite | Write-Function

        $RamDiskSetDataScriptContent += "
            while ((Get-ScheduledTask -TaskPath '\' -TaskName '$RamDiskTaskName') -eq 'Running')
            {
                Start-Sleep -Seconds 0.25
            }

            Set-DataToRamDisk -RamDiskName '$RamDiskName' -AppToRamDisk $($AppToRamDisk.ForEach({ "'$_'" }) -join ', ')
        " -replace '(?m)^ {12}'
        $RamDiskSetDataScriptContent
    }
}
