#=================================================================================================================
#                                   Personnalization > Device Usage - Settings
#=================================================================================================================

# Microsoft might offer personalized tips, ads, and recommendations within Microsoft experiences.

# Recommendation: All Disabled

<#
.SYNTAX
    Set-DeviceUsageSetting
        [-Value] {Creativity | Business | Development | Entertainment | Family | Gaming | School}
        [<CommonParameters>]

    Set-DeviceUsageSetting
        -DisableAll
        [<CommonParameters>]
#>

function Set-DeviceUsageSetting
{
    <#
    .EXAMPLE
        PS> Set-DeviceUsageSetting -Value 'Development', 'Entertainment'

    .EXAMPLE
        PS> Set-DeviceUsageSetting -DisableAll
    #>

    [CmdletBinding(DefaultParameterSetName = 'Value')]
    param
    (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Value')]
        [ValidateSet('Creativity', 'Business', 'Development', 'Entertainment', 'Family', 'Gaming', 'School')]
        [string[]] $Value,

        [Parameter(Mandatory, ParameterSetName = 'Disable')]
        [switch] $DisableAll
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Disable' -and $false -eq $DisableAll)
        {
            return
        }

        $KeyName = @{
            Creativity    = 'creative'
            Business      = 'business'
            Development   = 'developer'
            Entertainment = 'entertainment'
            Family        = 'family'
            Gaming        = 'gaming'
            School        = 'schoolwork'
        }

        foreach ($Key in $KeyName.Keys)
        {
            $IsEnabled = $Value -contains $Key

            # on: 1 0 | off: 0 0 (default)
            $DeviceUsage = @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = "Software\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Intent\$($KeyName.$Key)"
                Entries = @(
                    @{
                        Name  = 'Intent'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'Priority'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }

            Write-Verbose -Message "Setting 'Device Usage: $Key' to '$($IsEnabled ? 'Enabled' : 'Disabled')' ..."
            Set-RegistryEntry -InputObject $DeviceUsage
        }

        $IsDeviceUsageEnabled = $null -ne $Value

        # If at least one 'Device Usage' option is enabled, 'Device Usage Consent' must be accepted.
        # on: 1 | off: 0 (default)
        $DeviceUsageConsent = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Intent\OffDeviceConsent'
            Entries = @(
                @{
                    Name  = 'accepted'
                    Value = $IsDeviceUsageEnabled ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Device Usage Consent' to '$($IsDeviceUsageEnabled ? 'Accepted' : 'NotAccepted')' ..."
        Set-RegistryEntry -InputObject $DeviceUsageConsent
    }
}
