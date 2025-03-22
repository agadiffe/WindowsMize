#=================================================================================================================
#                          MSOffice - Options > General > Optional Connected Experiences
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeConnectedExperiences
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MSOfficeConnectedExperiences
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeConnectedExperiences -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $Value = $State -eq 'Enabled' ? '1' : '2'

        # on: 1 (default) | off: 2
        $MSOfficeConnectedExperiences = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Policies\Microsoft\Office\16.0\Common\Privacy'
                Entries = @(
                    @{
                        Name  = 'ControllerConnectedServicesEnabled'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\Common\Privacy\SettingsStore\Anonymous'
                Entries = @(
                    @{
                        Name  = 'ControllerConnectedServicesState'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'MSOffice - Optional Connected Experiences' to '$State' ..."
        $MSOfficeConnectedExperiences | Set-RegistryEntry
    }
}
