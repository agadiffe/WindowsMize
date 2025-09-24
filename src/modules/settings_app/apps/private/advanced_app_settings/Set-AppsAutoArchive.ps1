#=================================================================================================================
#                                   Apps > Advanced App Settings > Archive Apps
#=================================================================================================================

<#
.SYNTAX
    Set-AppsAutoArchive
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppsAutoArchive
{
    <#
    .EXAMPLE
        PS> Set-AppsAutoArchive -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoState] $GPO
    )

    process
    {
        $ArchiveAppsMsg = 'Apps - Archive Apps'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                $UserSid = (Get-LoggedOnUserInfo).Sid

                # on: 1 (default) | off: 0
                $ArchiveApps = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = "SOFTWARE\Microsoft\Windows\CurrentVersion\InstallService\Stubification\$UserSid"
                    Entries = @(
                        @{
                            Name  = 'EnableAppOffloading'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ArchiveAppsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $ArchiveApps
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app package deployment
                #   archive infrequently used apps
                # not configured: delete (default) | on: 1 | off: 0
                $ArchiveAppsGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\Appx'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'AllowAutomaticAppArchiving'
                            Value = $GPO -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ArchiveAppsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $ArchiveAppsGpo
            }
        }
    }
}
