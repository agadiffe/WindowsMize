#=================================================================================================================
#                                         Write Script : RamDisk Creation
#=================================================================================================================

<#
.SYNTAX
    Write-ScriptRamDiskCreation
        [-Name] <string>
        [-Size] <string>
        [<CommonParameters>]
#>

function Write-ScriptRamDiskCreation
{
    <#
    .EXAMPLE
        PS> Write-ScriptRamDiskCreation -Name 'RamDisk' -Size '1G'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [ValidatePattern(
            '^\d+[MG]$',
            ErrorMessage = 'Size format must be a number followed by M or G. (e.g. ''512M'' or ''2G'').')]
        [string] $Size
    )

    process
    {
        $FunctionsToWrite = @(
            'Get-LoggedOnUserInfo'
            'Get-ApplicationInfo'
            'New-RamDisk'
            'Get-DrivePath'
        )
        $RamDiskCreationScriptContent = $FunctionsToWrite | Write-Function

        # If you have multiple users, make sure to allocate enought RAM.
        # For Brave, allocate at least 512MB per profile.
        $RamDiskCreationScriptContent += "
            if (-not (Get-DrivePath -Name '$Name'))
            {
                New-RamDisk -Name '$Name' -Size '$Size'
            }
        " -replace '(?m)^ {0,12}'
        $RamDiskCreationScriptContent
    }
}
