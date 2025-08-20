#=================================================================================================================
#                                          MSOffice - Privacy > Surveys
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeSurveys
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeSurveys
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeSurveys -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ user config > administrative tpl > microsoft office > privacy > trust center
        #   allow users to receive and respond to in-product surveys from Microsoft
        # not configured: delete (default) | off: 0
        $MSOfficeSurveysGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\Common\Feedback'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'SurveyEnabled'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - Surveys (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeSurveysGpo
    }
}
