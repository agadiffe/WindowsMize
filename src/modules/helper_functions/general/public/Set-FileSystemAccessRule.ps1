#=================================================================================================================
#                               Helper Function - Set FileSystem Admins FullControl
#=================================================================================================================

<#
.SYNTAX
    Set-FileSystemAccessRule
        -Path <string>
        -Sid <string>
        -Permission {Allow | Deny}
        -Access {FullControl | Modify | ReadAndExecute | Read | Write}
        [<CommonParameters>]

    Set-FileSystemAccessRule
        -Path <string>
        -Sid <string>
        -RemoveAll
        [<CommonParameters>]
#>

function Set-FileSystemAccessRule
{
    <#
    .DESCRIPTION
        Does not work if the 'SID' permission is an inherited ACE.
        Basic implementation tailored to WindowsMize needs.

    .EXAMPLE
        PS> Set-FileSystemAccessRule -Path 'C:\FooBar\' -Sid 'S-1-5-32-544' -Permission 'Allow' -Access 'FullControl'

    .EXAMPLE
        PS> Set-FileSystemAccessRule -Path 'C:\FooBar\' -Sid 'S-1-5-32-544' -RemoveAll
    #>

    [CmdletBinding(DefaultParameterSetName = 'AllowDeny')]
    param
    (
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Sid,

        [Parameter(Mandatory, ParameterSetName = 'AllowDeny')]
        [ValidateSet('Allow', 'Deny')]
        [string] $Permission,

        [Parameter(Mandatory, ParameterSetName = 'AllowDeny')]
        [ValidateSet('FullControl', 'Modify', 'ReadAndExecute', 'Read', 'Write')]
        [string[]] $Access,
        
        [Parameter(Mandatory, ParameterSetName = 'RemoveAll')]
        [switch] $RemoveAll
    )

    process
    {
        $AccountSid = [System.Security.Principal.SecurityIdentifier]::new($Sid)
        $Acl = Get-Acl -Path $Path

        if ($PSCmdlet.ParameterSetName -eq 'AllowDeny')
        {
            $Ace = [System.Security.AccessControl.FileSystemAccessRule]::new($AccountSid, $Access, $Permission)
            $Acl.SetAccessRule($Ace) | Out-Null
        }
        else
        {
            if ($RemoveAll)
            {
                $AccountName = $AccountSid.Translate([System.Security.Principal.NTAccount]).Value
                $Acl.Access |
                    Where-Object -Property 'IdentityReference' -EQ -Value $AccountName |
                    ForEach-Object -Process { $Acl.RemoveAccessRule($_) | Out-Null }
            }
        }
        Set-Acl -Path $Path -AclObject $Acl | Out-Null
    }
}
