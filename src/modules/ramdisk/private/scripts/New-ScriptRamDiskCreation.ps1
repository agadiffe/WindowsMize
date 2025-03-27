#=================================================================================================================
#                                          New Script : RamDisk Creation
#=================================================================================================================

<#
.SYNTAX
    New-ScriptRamDiskCreation
        [-FilePath] <string>
        [-Name] <string>
        [-Size] <string>
        [<CommonParameters>]
#>

function New-ScriptRamDiskCreation
{
    <#
    .EXAMPLE
        PS> New-ScriptRamDiskCreation -FilePath 'C:\MyScript.ps1' -Name 'RamDisk' -Size '1G'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath,

        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [ValidatePattern(
            '^\d[MG]$',
            ErrorMessage = 'Size format must be a number followed by M or G. (e.g. ''512M'' or ''2G'').')]
        [ValidateRange('NonNegative')]
        [string] $Size
    )

    process
    {
        Write-Verbose -Message 'Setting ''RamDisk - Creation'' Script ...'

        New-ParentPath -Path $FilePath
        Write-ScriptRamDiskCreation -RamDiskName $Name -Size $Size | Out-File -FilePath $FilePath
    }
}
