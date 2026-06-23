#=================================================================================================================
#                             MSOffice - Options > Save > Save To Computer By Default
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeDefaultSaveLocation
        [-Location] {Computer | Cloud}
        [<CommonParameters>]
#>

function Set-MSOfficeDefaultSaveLocation
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeDefaultSaveLocation -Location 'Computer'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [OfficeSaveLocation] $Location
    )

    process
    {
        $IsPreferCloud = $Location -eq 'Cloud'

        # on: 1 (default) | off: 0
        $MSOfficeDefaultSaveLocation = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Office\16.0\Common\General'
            Entries = @(
                @{
                    Name  = 'PreferCloudSaveLocations'
                    Value = $IsPreferCloud ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        $SettingState = $IsPreferCloud ? 'Disabled' : 'Enabled'
        Write-Verbose -Message "Setting 'MSOffice - Save To Computer By Default' to '$SettingState' ..."
        Set-RegistryEntry -InputObject $MSOfficeDefaultSaveLocation
    }
}
