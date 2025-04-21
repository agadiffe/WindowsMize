#=================================================================================================================
#                               Accessibility > Visual Effects > Animation Effects
#=================================================================================================================

<#
.SYNTAX
    Set-VisualEffectsAnimation
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-VisualEffectsAnimation
{
    <#
    .EXAMPLE
        PS> Set-VisualEffectsAnimation -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # default: Enabled

        Write-Verbose -Message "Setting 'Visual Effects - Animation Effects' to '$State' ..."
        Set-VisualEffects -Value 'Animation' -State $State
    }
}
