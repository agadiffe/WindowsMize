#=================================================================================================================
#                                  Security Questions Feature For Local Accounts
#=================================================================================================================

<#
.SYNTAX
    Set-LocalAccountsSecurityQuestions
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-LocalAccountsSecurityQuestions
{
    <#
    .EXAMPLE
        PS> Set-LocalAccountsSecurityQuestions -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > credential user interface
        #   prevent the use of security questions for local accounts
        # not configured: delete (default) | on: 1
        $LocalAccountsSecurityQuestionsGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\System'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'NoLocalPasswordResetQuestions'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Security Questions Feature For Local Accounts (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $LocalAccountsSecurityQuestionsGpo
    }
}
