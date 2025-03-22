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
        # 'BUILTIN\Administrators'
        $AdminsIdentityReference = [System.Security.Principal.SecurityIdentifier]::new('S-1-5-32-544')
        $AdminsSystemAccessRule = [System.Security.AccessControl.FileSystemAccessRule]::new(
            $AdminsIdentityReference, 'FullControl', 'Allow'
        )

        $Acl = Get-Acl -Path $Path
        switch ($Action)
        {
            'Grant'  { $Acl.SetAccessRule($AdminsSystemAccessRule) | Out-Null }
            'Remove' { $Acl.RemoveAccessRule($AdminsSystemAccessRule) | Out-Null }
        }
        Set-Acl -Path $Path -AclObject $Acl | Out-Null
    }
}
