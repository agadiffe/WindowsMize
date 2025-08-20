#=================================================================================================================
#                          MSOffice - Privacy > Customer Experience Improvement Program
#=================================================================================================================

# If not configured, users have the opportunity to opt into participation in the CEIP the first time they run
# an Office application.

<#
.SYNTAX
    Set-MSOfficeCeip
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeCeip
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeCeip -GPO 'Disabled'
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
        #   enable Customer Experience Improvement Program
        # not configured: delete (default) | off: 0
        $MSOfficeCeipGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\Common'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'QMEnable'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - Customer Experience Improvement Program (CEIP) (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeCeipGpo
    }
}
