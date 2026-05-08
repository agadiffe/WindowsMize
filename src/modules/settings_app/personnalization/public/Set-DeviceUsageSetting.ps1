#=================================================================================================================
#                                   Personnalization > Device Usage - Settings
#=================================================================================================================

# Microsoft might offer personalized tips, ads, and recommendations within Microsoft experiences.

# Recommendation: All Disabled

<#
.SYNTAX
    Set-DeviceUsageSetting
        [-Usage] {Creativity | Business | Development | Entertainment | Family | Gaming | School}
        [<CommonParameters>]

    Set-DeviceUsageSetting
        -DisableAll
        [<CommonParameters>]
#>

function Set-DeviceUsageSetting
{
    <#
    .EXAMPLE
        PS> Set-DeviceUsageSetting -Usage 'Development', 'Entertainment'

    .EXAMPLE
        PS> Set-DeviceUsageSetting -DisableAll
    #>

    [CmdletBinding(DefaultParameterSetName = 'Usage')]
    param
    (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Usage')]
        [ValidateSet('Creativity', 'Business', 'Development', 'Entertainment', 'Family', 'Gaming', 'School')]
        [string[]] $Usage,

        [Parameter(Mandatory, ParameterSetName = 'Disable')]
        [switch] $DisableAll
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Disable' -and -not $DisableAll)
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
            $IsEnabled = $Usage -contains $Key

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

        $IsDeviceUsageEnabled = $null -ne $Usage

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
