#=================================================================================================================
#                                               Location Permission
#=================================================================================================================

<#
.SYNTAX
    Set-LocationPermission
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-LocationPermission
{
    <#
    .EXAMPLE
        PS> Set-LocationPermission -GPO 'Disabled'
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
        #   turn off location
        # not configured: delete (default) | off: 1
        $LocationPermissionGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableLocation'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Location Permission (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $LocationPermissionGpo
    }
}
