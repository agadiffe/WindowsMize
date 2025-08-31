#=================================================================================================================
#                                               Sensors Permission
#=================================================================================================================

<#
.SYNTAX
    Set-SensorsPermission
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-SensorsPermission
{
    <#
    .EXAMPLE
        PS> Set-SensorsPermission -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > location and sensors
        #   turn off sensors
        # not configured: delete (default) | off: 1
        $SensorsPermissionGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableSensors'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Sensors Permission (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $SensorsPermissionGpo
    }
}
