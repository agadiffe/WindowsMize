#=================================================================================================================
#                                          New Script : RamDisk Set Data
#=================================================================================================================

<#
.SYNTAX
    New-ScriptRamDiskSetData
        [-FilePath] <string>
        [-RamDiskName] <string>
        [-RamDiskTaskName] <string>
        [-AppToRamDisk] {Brave | VSCode}
        [<CommonParameters>]
#>

function New-ScriptRamDiskSetData
{
    <#
    .EXAMPLE
        PS> $ScriptSetDataParam = @{
                FilePath        = 'C:\MyScript.ps1'
                RamDiskName     = 'RamDisk'
                RamDiskTaskName = 'RamDisk - Creation'
                AppToRamDisk    = 'Brave', 'VSCode'
            }
        PS> New-ScriptRamDiskSetData @ScriptSetDataParam
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath,

        [Parameter(Mandatory)]
        [string] $RamDiskName,

        [Parameter(Mandatory)]
        [string] $RamDiskTaskName,

        [Parameter(Mandatory)]
        [AppName[]] $AppToRamDisk
    )

    process
    {
        Write-Verbose -Message 'Setting ''RamDisk - Set Data'' Script ...'

        New-ParentPath -Path $FilePath
        $ScriptSetDataParam = @{
            RamDiskName     = $RamDiskName
            RamDiskTaskName = $RamDiskCreationTaskName
            AppToRamDisk    = $AppToRamDisk
        }
        Write-ScriptRamDiskSetData @ScriptSetDataParam | Out-File -FilePath $FilePath
    }
}
