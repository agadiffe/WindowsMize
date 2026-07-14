#=================================================================================================================
#                               MSOffice - Privacy > AI Content Safety
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeAIContentSafety
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeAIContentSafety
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeAIContentSafety -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ user config > administrative tpl > microsoft office > ai > content safety > general
        #   disable local content safety in general for the user
        # not configured: delete (default) | on: 1
        $MSOfficeAIContentSafetyGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\Common\ai\contentsafety\general'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableContentSafety'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - AI Content Safety (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeAIContentSafetyGpo
    }
}
