#=================================================================================================================
#                                            New RamDisk User Profile
#=================================================================================================================

<#
.SYNTAX
    New-RamDiskUserProfile
        [-Path] <string>
        [<CommonParameters>]
#>

function New-RamDiskUserProfile
{
    <#
    .EXAMPLE
        PS> New-RamDiskUserProfile -Path 'X:\UserName'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $Path
    )

    process
    {
        New-Item -Path $Path -ItemType 'Directory' | Out-Null
        $UserProfilePath = (Get-LoggedOnUserEnvVariable).USERPROFILE
        $UserProfileAcl = Get-Acl -Path $UserProfilePath
        Set-Acl -Path $Path -AclObject $UserProfileAcl
    }
}
