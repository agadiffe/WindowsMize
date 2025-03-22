#=================================================================================================================
#                                          New Script : RamDisk Creation
#=================================================================================================================

<#
.SYNTAX
    New-ScriptRamDiskCreation
        [-FilePath] <string>
        [-RamDiskName] <string>
        [<CommonParameters>]
#>

function New-ScriptRamDiskCreation
{
    <#
    .EXAMPLE
        PS> New-ScriptRamDiskCreation -FilePath 'C:\MyScript.ps1' -RamDiskName 'RamDisk'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath,

        [Parameter(Mandatory)]
        [string] $RamDiskName
    )

    process
    {
        Write-Verbose -Message 'Setting ''RamDisk - Creation'' Script ...'

        New-ParentPath -Path $FilePath
        Write-ScriptRamDiskCreation -RamDiskName $RamDiskName | Out-File -FilePath $FilePath
    }
}
