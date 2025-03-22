#=================================================================================================================
#                                            Power Options - Hibernate
#=================================================================================================================

# control panel (icons view) > power options > choose what the power button do
# (control.exe /name Microsoft.PowerOptions /page pageGlobalSettings)

# default: Enabled

<#
.SYNTAX
    Set-Hibernate
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-Hibernate
{
    <#
    .DESCRIPTION
        Disabling 'Hibernate' will also disable 'Fast startup'.

    .EXAMPLE
        PS> Set-Hibernate -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        Write-Verbose -Message "Setting 'Hibernate' to '$State' ..."
        powercfg.exe -Hibernate ($State -eq 'Enabled' ? 'on' : 'off')
    }
}
