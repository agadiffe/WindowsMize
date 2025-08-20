#=================================================================================================================
#                                 MSOffice - Privacy > Opt-In Wizard On First Run
#=================================================================================================================

# The Opt-in Wizard displays the first time users run a Microsoft Office 2016 application.
# Provide choices to the user to opt into services such as:
#   Microsoft Update
#   New software notifications
#   Customer Experience Improvement Program
#   Office Diagnostics
#   Online Help
#   Online Search Relevancy

<#
.SYNTAX
    Set-MSOfficeFirstRunOptinWizard
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeFirstRunOptinWizard
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeFirstRunOptinWizard -GPO 'Disabled'
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

        # gpo\ user config > administrative tpl > microsoft office > miscellaneous
        #   supress recommended settings dialog (on first run)
        # not configured: delete (default) | on: 1
        #
        # gpo\ user config > administrative tpl > microsoft office > privacy > trust center
        #   disable opt-in wizard on first run
        # not configured: delete (default) | on: 1
        $MSOfficeFirstRunOptinWizardGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\Common\General'
            Entries = @(
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'OptInDisable'
                    Value = '1'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'ShownFirstRunOptIn'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - Opt-In Wizard On First Run (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeFirstRunOptinWizardGpo
    }
}
