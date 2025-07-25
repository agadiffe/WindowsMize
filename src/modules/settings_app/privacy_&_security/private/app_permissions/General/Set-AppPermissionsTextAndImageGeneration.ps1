#=================================================================================================================
#                        Privacy & Security > App Permissions > Text And Image Generation
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsTextAndImageGeneration
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsTextAndImageGeneration
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsTextAndImageGeneration -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoState] $GPO
    )

    process
    {
        $GenerativeAIMsg = 'Text And Image Generation'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $GenerativeAI = [AppPermissionAccess]::new('systemAIModels', $State)
                $GenerativeAI.WriteVerboseMsg($GenerativeAIMsg)
                $GenerativeAI.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps make use of text and image generation features of Windows
                # not configured: delete (default) | on: 1 | off: 2

                $GenerativeAIGpo = [AppPermissionPolicy]::new('LetAppsAccessSystemAIModels', $GPO)
                $GenerativeAIGpo.WriteVerboseMsg("$GenerativeAIMsg (GPO)")
                $GenerativeAIGpo.SetRegistryEntry()
            }
        }
    }
}
