#=================================================================================================================
#                                 MSOffice - Privacy > Send Personal Information
#=================================================================================================================

# No longer applicable to Microsoft 365 App for enterprise, starting with Version 1904.

<#
.SYNTAX
    Set-MSOfficeSendPersonalInfo
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeSendPersonalInfo
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeSendPersonalInfo -GPO 'Disabled'
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
        #   send personal information
        # not configured: delete (default) | off: 0
        $MSOfficeSendPersonalInfoGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\Common'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'SendCustomerData'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - Send Personal Information (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeSendPersonalInfoGpo
    }
}
