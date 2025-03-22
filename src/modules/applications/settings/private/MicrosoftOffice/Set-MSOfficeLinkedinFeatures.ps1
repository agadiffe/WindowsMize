#=================================================================================================================
#                                MSOffice - Options > General > Linkedin Features
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeLinkedinFeatures
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MSOfficeLinkedinFeatures
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeLinkedinFeatures -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $Value = $State -eq 'Enabled' ? '1' : '0'

        # on: 1 (default) | off: 0
        $MSOfficeLinkedinFeatures = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Policies\Microsoft\Office\16.0\Common'
                Entries = @(
                    @{
                        Name  = 'LinkedIn'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\Common\LinkedIn'
                Entries = @(
                    @{
                        Name  = 'OfficeLinkedIn'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'MSOffice - Linkedin Features' to '$State' ..."
        $MSOfficeLinkedinFeatures | Set-RegistryEntry
    }
}
