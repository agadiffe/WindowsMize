#=================================================================================================================
#                                      Telemetry - Application Compatibility
#=================================================================================================================

# While the application compatibility features are not directly related to telemetry or
# privacy concerns, they do involve some data collection and analysis of application behavior.

<#
.SYNTAX
    Set-ApplicationCompatibility
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-ApplicationCompatibility
{
    <#
    .EXAMPLE
        PS> Set-ApplicationCompatibility -GPO 'Disabled'
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

        # gpo\ computer config > administrative tpl > windows components > application compatibility
        #   turn off application compatibility engine
        #   turn off program compatibility assistant
        #   turn off switchback compatibility engine
        # not configured: delete (default) | on: 1 1 0
        $ApplicationCompatibilityGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\AppCompat'
            Entries = @(
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'DisableEngine'
                    Value = '1'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'DisablePCA'
                    Value = '1'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'SbEnable'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Application Compatibility (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $ApplicationCompatibilityGpo
    }
}
