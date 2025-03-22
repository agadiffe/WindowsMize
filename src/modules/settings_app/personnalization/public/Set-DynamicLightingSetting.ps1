#=================================================================================================================
#                                 Personnalization > Dynamic Lighting - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-DynamicLightingSetting
        [-DynamicLighting {Disabled | Enabled}]
        [-ControlledByForegroundApp {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-DynamicLightingSetting
{
    <#
    .EXAMPLE
        PS> Set-DynamicLightingSetting -DynamicLighting 'Disabled' -ControlledByForegroundApp 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $DynamicLighting,

        [state] $ControlledByForegroundApp
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'DynamicLighting'           { Set-DynamicLighting -State $DynamicLighting }
            'ControlledByForegroundApp' { Set-DynamicLightingControlledByForegroundApp -State $ControlledByForegroundApp }
        }
    }
}
