#=================================================================================================================
#                               MSOffice - Misc > First Run About Sign-In To Office
#=================================================================================================================

# A video about signing-in to Office is played when Office first runs.
# The Office First Run about signing-in to Office comes up on first application boot.

<#
.SYNTAX
    Set-MSOfficeFirstRunAboutSignin
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeFirstRunAboutSignin
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeFirstRunAboutSignin -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $IsNotConfigured = $GPO -eq 'NotConfigured'

        # gpo\ user config > administrative tpl > microsoft office > first run
        #   disable first run movie
        # not configured: delete (default) | on: 1
        #
        # gpo\ user config > administrative tpl > microsoft office > first run
        #   disable Office first run on application boot
        # not configured: delete (default) | on: 1
        $MSOfficeFirstRunAboutSigninGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\FirstRun'
            Entries = @(
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'DisableMovie'
                    Value = '1'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'BootedRtm'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - First Run About Sign-In To Office (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeFirstRunAboutSigninGpo
    }
}
