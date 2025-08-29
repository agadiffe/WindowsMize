#=================================================================================================================
#                                          Location Scripting Permission
#=================================================================================================================

<#
.SYNTAX
    Set-LocationScriptingPermission
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-LocationScriptingPermission
{
    <#
    .EXAMPLE
        PS> Set-LocationScriptingPermission -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoState] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > location and sensors
        #   turn off location scripting
        # not configured: delete (default) | off: 1
        $LocationScriptingPermissionGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableLocationScripting'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Location Scripting Permission (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $LocationScriptingPermissionGpo
    }
}
