#=================================================================================================================
#                                         Write Script : RamDisk Creation
#=================================================================================================================

<#
.SYNTAX
    Write-ScriptRamDiskCreation
        [-RamDiskName] <string>
        [<CommonParameters>]
#>

function Write-ScriptRamDiskCreation
{
    <#
    .EXAMPLE
        PS> Write-ScriptRamDiskCreation -RamDiskName 'RamDisk'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $RamDiskName
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
        # For Brave, allocate at least 256MB per profile.
        $RamDiskCreationScriptContent += "
            if (-not (Get-DrivePath -Name '$RamDiskName'))
            {
                New-RamDisk -Name '$RamDiskName' -Size '1G'
            }
        " -replace '(?m)^ {12}'
        $RamDiskCreationScriptContent
    }
}
