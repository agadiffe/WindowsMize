#=================================================================================================================
#                                     MSOffice - Options > Privacy > Feedback
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeFeedback
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MSOfficeFeedback
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeFeedback -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $Value = $State -eq 'Enabled' ? '1' : '0'

        # on: 1 (default) | off: 0
        $MSOfficeFeedback = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Policies\Microsoft\Office\16.0\Common\Feedback'
                Entries = @(
                    @{
                        Name  = 'Enabled'
                        Value = $Value
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'IncludeEmail'
                        Value = $Value
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'SurveyEnabled'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\Common\Feedback'
                Entries = @(
                    @{
                        Name  = 'Enabled'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'MSOffice - Feedback' to '$State' ..."
        $MSOfficeFeedback | Set-RegistryEntry
    }
}
