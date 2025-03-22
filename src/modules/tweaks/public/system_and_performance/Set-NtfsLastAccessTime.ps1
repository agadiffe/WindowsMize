#=================================================================================================================
#                                              NTFS Last Access Time
#=================================================================================================================

# Reduces the impact of logging updates to the Last Access Time stamp, which can
# potentially improve file system performance and lower SSD writes.

<#
.SYNTAX
    Set-NtfsLastAccessTime
        [-Managed] {User | System}
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NtfsLastAccessTime
{
    <#
    .EXAMPLE
        PS> Set-NtfsLastAccessTime -Managed 'User' -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('User', 'System')]
        [string] $Managed,

        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # 0: User Managed, Last Access Time Updates Enabled
        # 1: User Managed, Last Access Time Updates Disabled
        # 2: System Managed, Last Access Time Updates Enabled (default)
        # 3: System Managed, Last Access Time Updates Disabled

        Write-Verbose -Message "Setting 'NTFS Last Access Time' to '$Managed Managed: $State' ..."

        $Value = $State -eq 'Enabled' ? 0 : 1
        if ($Managed -eq 'System')
        {
            $Value += 2
        }
        fsutil.exe behavior set DisableLastAccess $Value | Out-Null
    }
}
