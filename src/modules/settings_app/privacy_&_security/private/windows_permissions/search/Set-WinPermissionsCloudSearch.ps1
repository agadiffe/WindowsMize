#=================================================================================================================
#                                Privacy & Security > Search > Search My Accounts
#=================================================================================================================

# Search my accounts
#   Microsoft account
#   Work or School account

<#
.SYNTAX
    Set-WinPermissionsCloudSearch
        [-MicrosoftAccount {Disabled | Enabled}]
        [-WorkOrSchoolAccount {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsCloudSearch
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsCloudSearch -MicrosoftAccount 'Disabled' -WorkOrSchoolAccount 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $MicrosoftAccount,

        [state] $WorkOrSchoolAccount,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $WinPermissionsCloudSearchMsg = 'Windows Permissions - Search: Search My Accounts'

        switch ($PSBoundParameters.Keys)
        {
            'MicrosoftAccount'
            {
                # on: 1 (default) | off: 0
                $WinPermissionsCloudSearchMicrosoftAccount = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\SearchSettings'
                    Entries = @(
                        @{
                            Name  = 'IsMSACloudSearchEnabled'
                            Value = $MicrosoftAccount -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsCloudSearchMsg MicrosoftAccount' to '$MicrosoftAccount' ..."
                Set-RegistryEntry -InputObject $WinPermissionsCloudSearchMicrosoftAccount
            }
            'WorkOrSchoolAccount'
            {
                # on: 1 (default) | off: 0
                $WinPermissionsCloudSearchWorkOrSchoolAccount = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\SearchSettings'
                    Entries = @(
                        @{
                            Name  = 'IsAADCloudSearchEnabled'
                            Value = $WorkOrSchoolAccount -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsCloudSearchMsg WorkOrSchoolAccount' to '$WorkOrSchoolAccount' ..."
                Set-RegistryEntry -InputObject $WinPermissionsCloudSearchWorkOrSchoolAccount
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > search
                #   allow cloud search
                # not configured: delete (default) | off: 0
                $WinPermissionsCloudSearchGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\Windows Search'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'AllowCloudSearch'
                            Value = '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsCloudSearchMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsCloudSearchGpo
            }
        }
    }
}
