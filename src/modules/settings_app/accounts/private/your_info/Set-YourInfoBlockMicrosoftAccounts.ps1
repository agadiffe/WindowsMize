#=================================================================================================================
#                                     Accounts > Your Info > Account Settings
#=================================================================================================================

# If enabled, disable and gray out: settings > bluetooth & devices > mobile devices

<#
.SYNTAX
    Set-YourInfoBlockMicrosoftAccounts
        [-GPO] {CannotAddMicrosoftAccount | CannotAddOrLogonWithMicrosoftAccount | NotConfigured}
        [<CommonParameters>]
#>

function Set-YourInfoBlockMicrosoftAccounts
{
    <#
    .EXAMPLE
        PS> Set-YourInfoBlockMicrosoftAccounts -GPO 'NotConfigured'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [BlockMSAccountsMode] $GPO
    )

    process
    {
        # gpo\ computer config > windows settings > security settings > local policies > security options
        #   accounts: block Microsoft accounts
        # not defined: delete (default) | this policy is disabled: 0
        # users can't add Microsoft accounts: 1 | users can't add or log on with Microsoft accounts: 3
        $BlockMicrosoftAccountsGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'NoConnectedUser'
                    Value = [int]$GPO
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Your Info - Block Microsoft Accounts (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $BlockMicrosoftAccountsGpo
    }
}
