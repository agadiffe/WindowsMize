#=================================================================================================================
#                                      MSOffice - Privacy > Accept All EULAs
#=================================================================================================================

# EULA : End-User License Agreement

<#
.SYNTAX
    Set-MSOfficeAcceptEULAs
        [-GPO] {Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeAcceptEULAs
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeAcceptEULAs -GPO 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutDisabled] $GPO
    )

    process
    {
        # gpo\ user config > administrative tpl > microsoft office > privacy > trust center
        #   Accept all EULAs
        # not configured: delete (default) | on: 1
        $MSOfficeAcceptEULAsGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\Registration'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'AcceptAllEULAsPolicy'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - Accept All EULAs (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeAcceptEULAsGpo
    }
}
