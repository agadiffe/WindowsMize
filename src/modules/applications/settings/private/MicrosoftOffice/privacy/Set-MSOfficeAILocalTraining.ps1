#=================================================================================================================
#                                 MSOffice - Misc > Local Training Of AI Features
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeAILocalTraining
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeAILocalTraining
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeAILocalTraining -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ user config > administrative tpl > microsoft office > ai > training > general
        #   disable local training of all features for the user
        # not configured: delete (default) | on: 1
        $MSOfficeAILocalTrainingGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\Common\ai\training\general'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableTraining'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - Local Training Of AI Features (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeAILocalTrainingGpo
    }
}
