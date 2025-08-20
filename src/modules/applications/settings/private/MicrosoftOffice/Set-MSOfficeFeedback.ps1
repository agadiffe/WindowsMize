#=================================================================================================================
#                                          MSOffice - Privacy > Feedback
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeFeedback
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeFeedback
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeFeedback -GPO 'Disabled'
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
        #   allow users to submit feedback to Microsoft
        # not configured: delete (default) | off: 0
        $MSOfficeFeedbackGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\Common\Feedback'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'Enabled'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - Feedback (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeFeedbackGpo
    }
}
