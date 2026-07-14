#=================================================================================================================
#                                        MSOffice - Privacy > AI Training
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeAITraining
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeAITraining
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeAITraining -GPO 'Disabled'
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
        $MSOfficeAITrainingGpo = @{
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

        Write-Verbose -Message "Setting 'MSOffice - AI Training (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeAITrainingGpo
    }
}
