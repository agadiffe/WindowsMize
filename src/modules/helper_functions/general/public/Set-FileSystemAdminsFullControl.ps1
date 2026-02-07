#=================================================================================================================
#                               Helper Function - Set FileSystem Admins FullControl
#=================================================================================================================

<#
.SYNTAX
    Set-FileSystemAdminsFullControl
        [-Path] <string>
        [-Action] {Grant | Remove}
        [<CommonParameters>]
#>

function Set-FileSystemAdminsFullControl
{
    <#
    .DESCRIPTION
        Does not work if 'BUILTIN\Administrators' have an inherited ACE.
        Very basic implementation tailored to WindowsMize needs.

    .EXAMPLE
        PS> Set-FileSystemAdminsFullControl -Action 'Grant' -Path 'C:\FooBar\'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [ValidateSet('Grant', 'Remove')]
        [string] $Action
    )

    process
    {
        $AdminsSid = [System.Security.Principal.SecurityIdentifier]::new('S-1-5-32-544') # 'BUILTIN\Administrators'
        $AdminsAce = [System.Security.AccessControl.FileSystemAccessRule]::new($AdminsSid, 'FullControl', 'Allow')

        $Acl = Get-Acl -Path $Path
        switch ($Action)
        {
            'Grant'  { $Acl.SetAccessRule($AdminsAce) | Out-Null }
            'Remove' { $Acl.RemoveAccessRuleAll($AdminsAce) | Out-Null }
        }
        Set-Acl -Path $Path -AclObject $Acl | Out-Null
    }
}
