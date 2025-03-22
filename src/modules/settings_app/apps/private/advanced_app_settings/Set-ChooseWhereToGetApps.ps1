#=================================================================================================================
#                             Apps > Advanced App Settings > Choose Where To Get Apps
#=================================================================================================================

# Anywhere
# Anywhere, but let me know if there's a comparable app in the Microsoft Store
# Anywhere, but warn me before installing an app that's not from the Microsoft Store
# The Microsoft Store only

<#
.SYNTAX
    Set-ChooseWhereToGetApps
        [[-Value] {Anywhere | AnywhereWithStoreNotif | AnywhereWithWarnIfNotStore | StoreOnly}]
        [-GPO {Anywhere | AnywhereWithStoreNotif | AnywhereWithWarnIfNotStore | StoreOnly | NotConfigured}]
        [<CommonParameters>]
#>

function Set-ChooseWhereToGetApps
{
    <#
    .EXAMPLE
        PS> Set-ChooseWhereToGetApps -Value 'Anywhere' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [AppInstallControl] $Value,

        [GpoAppInstallControl] $GPO
    )

    process
    {
        $WhereToGetAppsMsg = 'Apps - Choose Where To Get Apps'

        $RegValue = @{
            Anywhere                   = 'Anywhere'
            AnywhereWithStoreNotif     = 'Recommendations'
            AnywhereWithWarnIfNotStore = 'PreferStore'
            StoreOnly                  = 'StoreOnly'
        }

        switch ($PSBoundParameters.Keys)
        {
            'Value'
            {
                # Anywhere (default) | Recommendations | PreferStore | StoreOnly
                $WhereToGetApps = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer'
                    Entries = @(
                        @{
                            Name  = 'AicEnabled'
                            Value = $RegValue.$Value
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WhereToGetAppsMsg' to '$Value' ..."
                Set-RegistryEntry -InputObject $WhereToGetApps
            }
            'GPO'
            {
                $IsNotConfigured = $GPO -eq 'NotConfigured'

                # gpo\ computer config > administrative tpl > windows components > windows defender smartScreen > explorer
                #   configure app install control
                # not configured: delete (default) | on: 1 + string: same as 'Value'
                $WhereToGetAppsGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows Defender\SmartScreen'
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'ConfigureAppInstallControlEnabled'
                            Value = '1'
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'ConfigureAppInstallControl'
                            Value = $RegValue.$GPO
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WhereToGetAppsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WhereToGetAppsGpo
            }
        }
    }
}
