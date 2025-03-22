#=================================================================================================================
#                                            KeePassXC Run At Startup
#=================================================================================================================

<#
.SYNTAX
    Set-KeePassXCRunAtStartup
        [[-State] {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-KeePassXCRunAtStartup
{
    <#
    .EXAMPLE
        PS> Set-KeePassXCRunAtStartup -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [state] $State
    )

    process
    {
        $KeePassXCInfo = Get-ApplicationInfo -Name 'KeePassXC'
        if ($KeePassXCInfo)
        {
            # general > automatically launch KeePassXC at system startup
            # on: not-delete | off: delete
            $KeepassXCRunAtStartup = @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\Run'
                Entries = @(
                    @{
                        RemoveEntry = $State -eq 'Disabled'
                        Name  = 'KeePassXC'
                        Value = "$($KeePassXCInfo.InstallLocation)\KeePassXC.exe"
                        Type  = 'String'
                    }
                )
            }

            Write-Verbose -Message "Setting 'KeePassXC Run At Startup' to '$State' ..."
            Set-RegistryEntry -InputObject $KeepassXCRunAtStartup
        }
        else
        {
            Write-Verbose -Message 'KeePassXC is not installed'
        }
    }
}
