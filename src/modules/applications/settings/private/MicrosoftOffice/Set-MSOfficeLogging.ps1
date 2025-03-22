#=================================================================================================================
#                                     MSOffice - Options > Privacy > Logging
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeLogging
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MSOfficeLogging
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeLogging -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $IsEnabled = $State -eq 'Enabled'

        # on: 0 1 1 (default) | off: 1 0 0
        $MSOfficeLogging = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\OSM'
            Entries = @(
                @{
                    Name  = 'EnableFileObfuscation'
                    Value = $IsEnabled ? '0' : '1'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'EnableLogging'
                    Value = $IsEnabled ? '1' : '0'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'EnableUpload'
                    Value = $IsEnabled ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - Logging' to '$State' ..."
        Set-RegistryEntry -InputObject $MSOfficeLogging
    }
}
