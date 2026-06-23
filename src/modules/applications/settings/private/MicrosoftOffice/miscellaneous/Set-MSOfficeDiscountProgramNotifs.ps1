#=================================================================================================================
#          MSOffice - Misc > Show In-Product Notifications For The Microsoft Workplace Discount Program
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeDiscountProgramNotifs
        [-GPO] {Disabled | Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeDiscountProgramNotifs
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeDiscountProgramNotifs -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoState] $GPO
    )

    process
    {
        # gpo\ user config > administrative tpl > microsoft office > miscellaneous
        #   show in-product notifications for the Microsoft Workplace Discount Program
        # not configured: delete (default) | on: 1 | off: 0
        $MSOfficeDiscountProgramNotifsGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\Common\Personalization'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'HomeUseProgram'
                    Value = $GPO -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        $DiscountProgramMsg = 'Show In-Product Notifications For The Microsoft Workplace Discount Program'

        Write-Verbose -Message "Setting 'MSOffice - $DiscountProgramMsg (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeDiscountProgramNotifsGpo
    }
}
