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
        $RamDiskSetDataScriptContent = ,(Get-Content -Path "$PSScriptRoot\..\..\classes\Enums.ps1" |
            Where-Object -FilterScript { $_ -notlike '#*' })
        $FunctionsToWrite = @(
            'Get-UserInfo'
            'Get-UserSid'
            'Invoke-RegLoadUserHive'
            'Get-LoggedOnUserInfo'
            'Get-LoggedOnUserEnvVariable'
            'Get-BraveBrowserPathInfo'
            'Get-ProfilePathCombinations'
            'Get-BraveDataException'
            'Get-BraveDataToSymlink'
            'Get-VSCodeDataToSymlink'
            'Get-DataToSymlink'
            'New-ParentPath'
            'New-SymbolicLink'
            'New-SymbolicLinksPair'
            'Remove-SymbolicLink'
            'Copy-Data'
            'Copy-BraveDataForSymlink'
            'Copy-BravePersistentData'
            'New-RamDiskUserProfile'
            'Get-DrivePath'
            'Set-DataToRamDisk'
        )
        $RamDiskSetDataScriptContent += $FunctionsToWrite | Write-Function

        $RamDiskSetDataScriptContent += "
            `$Global:ProvidedUserName = '$((Get-LoggedOnUserInfo).UserName)'

            while ((Get-ScheduledTask -TaskPath '\' -TaskName '$RamDiskTaskName').State -eq 'Running')
            {
                Start-Sleep -Seconds 0.25
            }

            Set-DataToRamDisk -RamDiskName '$RamDiskName' -AppToRamDisk $($AppToRamDisk.ForEach({ "'$_'" }) -join ', ')
        " -replace '(?m)^ {0,12}'
        $RamDiskSetDataScriptContent
    }
}
