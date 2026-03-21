#=================================================================================================================
#                                           Set OneDrive Run At Startup
#=================================================================================================================

<#
.SYNTAX
    Set-OneDriveRunAtStartup
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-OneDriveRunAtStartup
{
    <#
    .EXAMPLE
        PS> Set-OneDriveRunAtStartup -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $OneDriveMsg = 'OneDrive - Run At Startup'
        $OneDriveStartupReg = Get-LoggedOnUserItemPropertyValue -Path 'Software\Microsoft\Windows\CurrentVersion\Run' -Name 'OneDrive'

        if ($OneDriveStartupReg)
        {
            $CurrentTimestamp = [BitConverter]::GetBytes((Get-Date).ToFileTime())

            # on: 02 00 00 00 (default) | off: 03 00 00 00
            $OneDriveRunAtStartup = @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run'
                Entries = @(
                    @{
                        Name  = 'OneDrive'
                        Value = $State -eq 'Enabled' ? '02 00 00 00 00 00 00 00 00 00 00 00' : '03 00 00 00 ' + $CurrentTimestamp
                        Type  = 'Binary'
                    }
                )
            }

            Write-Verbose -Message "Setting '$OneDriveMsg' to '$State' ..."
            Set-RegistryEntry -InputObject $OneDriveRunAtStartup
        }
        else
        {
            Write-Verbose -Message "Setting '$OneDriveMsg': Startup registry entry not found (OneDrive is not installed ?)."
        }
    }
}
