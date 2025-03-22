#=================================================================================================================
#                                  System > Multitasking - Snap Windows Settings
#=================================================================================================================

<#
.SYNTAX
    Set-SnapWindowsSetting
        [-SnapWindows {Disabled | Enabled}]
        [-SnapSuggestions {Disabled | Enabled}]
        [-ShowLayoutOnMaxButtonHover {Disabled | Enabled}]
        [-ShowLayoutOnTopScreen {Disabled | Enabled}]
        [-ShowSnappedWindowGroup {Disabled | Enabled}]
        [-SnapBeforeReachingScreenEdge {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-SnapWindowsSetting
{
    <#
    .EXAMPLE
        PS> Set-SnapWindowsSetting -SnapWindows 'Enabled' -ShowLayoutOnMaxButtonHover 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $SnapWindows,

        [state] $SnapSuggestions,

        [state] $ShowLayoutOnMaxButtonHover,

        [state] $ShowLayoutOnTopScreen,

        [state] $ShowSnappedWindowGroup,

        [state] $SnapBeforeReachingScreenEdge
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
            'SnapWindows'                  { Set-SnapWindows -State $SnapWindows }
            'SnapSuggestions'              { Set-SnapSuggestions -State $SnapSuggestions }
            'ShowLayoutOnMaxButtonHover'   { Set-SnapShowLayoutOnMaxButtonHover -State $ShowLayoutOnMaxButtonHover }
            'ShowLayoutOnTopScreen'        { Set-SnapShowLayoutOnTopScreen -State $ShowLayoutOnTopScreen }
            'ShowSnappedWindowGroup'       { Set-SnapShowSnappedWindowGroup -State $ShowSnappedWindowGroup }
            'SnapBeforeReachingScreenEdge' { Set-SnapBeforeReachingScreenEdge -State $SnapBeforeReachingScreenEdge }
        }
    }
}
