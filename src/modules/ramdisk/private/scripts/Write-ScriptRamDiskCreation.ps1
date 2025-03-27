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
            '^\d[MG]$',
            ErrorMessage = 'Size format must be a number followed by M or G. (e.g. ''512M'' or ''2G'').')]
        [ValidateRange('NonNegative')]
        [int] $Size
    )

    process
    {
        $FunctionsToWrite = @(
            'Get-LoggedOnUserUsername'
            'Get-LoggedOnUserSID'
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
        " -replace '(?m)^ {12}'
        $RamDiskCreationScriptContent
    }
}
