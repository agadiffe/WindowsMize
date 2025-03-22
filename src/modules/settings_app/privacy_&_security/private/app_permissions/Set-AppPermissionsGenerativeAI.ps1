#=================================================================================================================
#                              Privacy & Security > App Permissions > Generative AI
#=================================================================================================================

<#
.SYNTAX
    Set-AppPermissionsGenerativeAI
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AppPermissionsGenerativeAI
{
    <#
    .EXAMPLE
        PS> Set-AppPermissionsGenerativeAI -State 'Disabled' -GPO 'NotConfigured'
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
        $GenerativeAIMsg = 'Generative AI'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Allow (default) | off: Deny

                $GenerativeAI = [AppPermissionAccess]::new('generativeAI', $State)
                $GenerativeAI.WriteVerboseMsg($GenerativeAIMsg)
                $GenerativeAI.SetRegistryEntry()
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > app privacy
                #   let Windows apps make use of generative AI features of Windows
                # not configured: delete (default) | on: 1 | off: 2

                $GenerativeAIGpo = [AppPermissionPolicy]::new('LetAppsAccessGenerativeAI', $GPO)
                $GenerativeAIGpo.WriteVerboseMsg("$GenerativeAIMsg (GPO)")
                $GenerativeAIGpo.SetRegistryEntry()
            }
        }
    }
}
