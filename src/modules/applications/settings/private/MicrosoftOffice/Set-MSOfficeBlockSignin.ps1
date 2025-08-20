#=================================================================================================================
#                                       MSOffice - Misc > Block Sign-In Into Office
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeBlockSignin
        [-GPO] {Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeBlockSignin
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeBlockSignin -GPO 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutDisabled] $GPO
    )

    process
    {
        # gpo\ user config > administrative tpl > microsoft office > miscellaneous
        #   block signing into Office
        # not configured: delete (default)
        # on: Both IDs allowed (0), Microsoft Account only (1), Org ID only (2), None allowed (3)
        $MSOfficeBlockSigninGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\Common\Signin'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'SigninOptions'
                    Value = '3'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - Block Sign-In Into Office (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeBlockSigninGpo
    }
}
