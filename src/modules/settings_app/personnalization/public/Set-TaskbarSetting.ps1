#=================================================================================================================
#                                      Personnalization > Taskbar - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarSetting
        [-SearchBox {Hide | IconOnly | Box | IconAndLabel}]
        [-SearchBoxGPO {Hide | IconOnly | Box | IconAndLabel | NotConfigured}]
        [-TaskView {Disabled | Enabled}]
        [-TaskViewGPO {Disabled | NotConfigured}]
        [-EmojiAndMore {Never | WhileTyping | Always}]
        [-PenMenu {Disabled | Enabled}]
        [-TouchKeyboard {Never | Always | WhenNoKeyboard}]
        [-VirtualTouchpad {Disabled | Enabled}]
        [-HiddenIconMenu {Disabled | Enabled}]
        [-Alignment {Left | Center}]
        [-AutoHide {Disabled | Enabled}]
        [-ShowAppsBadges {Disabled | Enabled}]
        [-ShowAppsFlashing {Disabled | Enabled}]
        [-ShowOnAllDisplays {Disabled | Enabled}]
        [-ShowOnAllDisplaysGPO {Disabled | NotConfigured}]
        [-ShowAppsOnMultipleDisplays {AllTaskbars | MainAndTaskbarWhereAppIsOpen | TaskbarWhereAppIsOpen}]
        [-ShareAnyWindow {Disabled | Enabled}]
        [-FarCornerToShowDesktop {Disabled | Enabled}]
        [-GroupAndHideLabelsMainTaskbar {Always | WhenTaskbarIsFull | Never}]
        [-GroupAndHideLabelsOtherTaskbars {Always | WhenTaskbarIsFull | Never}]
        [-GroupAndHideLabelsGPO {Disabled | NotConfigured}]
        [-ShowJumplistOnHover {Disabled | Enabled}]
        [<CommonParameters>]

#>

function Set-TaskbarSetting
{
    <#
    .EXAMPLE
        PS> Set-TaskbarSetting -SearchBox 'Hide' -TaskView 'Disabled' -Alignment 'Center'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # taskbar items
        [SearchBoxMode] $SearchBox,
        [GpoSearchBoxMode] $SearchBoxGPO,
        [state] $TaskView,
        [GpoStateWithoutEnabled] $TaskViewGPO,

        # system tray icons
        [EmojiMode] $EmojiAndMore,
        [state] $PenMenu,
        [TouchKeyboardMode] $TouchKeyboard,
        [state] $VirtualTouchpad,

        # other system tray icons
        [state] $HiddenIconMenu,

        # taskbar behaviors
        [TaskbarAlignment] $Alignment,
        [state] $AutoHide,
        [state] $ShowAppsBadges,
        [state] $ShowAppsFlashing,
        [state] $ShowOnAllDisplays,
        [GpoStateWithoutEnabled] $ShowOnAllDisplaysGPO,
        [TaskbarAppsVisibility] $ShowAppsOnMultipleDisplays,
        [state] $ShareAnyWindow,
        [state] $FarCornerToShowDesktop,
        [TaskbarGroupingMode] $GroupAndHideLabelsMainTaskbar,
        [TaskbarGroupingMode] $GroupAndHideLabelsOtherTaskbars,
        [GpoStateWithoutEnabled] $GroupAndHideLabelsGPO,
        [state] $ShowJumplistOnHover
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
            'SearchBox'                       { Set-TaskbarSearchBox -Value $SearchBox }
            'SearchBoxGPO'                    { Set-TaskbarSearchBox -GPO $SearchBoxGPO }
            'TaskView'                        { Set-TaskbarTaskView -State $TaskView }
            'TaskViewGPO'                     { Set-TaskbarTaskView -GPO $TaskViewGPO }

            'EmojiAndMore'                    { Set-TaskbarEmojiAndMore -Value $EmojiAndMore }
            'PenMenu'                         { Set-TaskbarPenMenu -State $PenMenu }
            'TouchKeyboard'                   { Set-TaskbarTouchKeyboard -Value $TouchKeyboard }
            'VirtualTouchpad'                 { Set-TaskbarVirtualTouchpad -State $VirtualTouchpad }

            'HiddenIconMenu'                  { Set-TaskbarHiddenIconMenu -State $HiddenIconMenu }

            'Alignment'                       { Set-TaskbarAlignment -Value $Alignment }
            'AutoHide'                        { Set-TaskbarAutoHide -State $AutoHide }
            'ShowAppsBadges'                  { Set-TaskbarShowAppsBadges -State $ShowAppsBadges }
            'ShowAppsFlashing'                { Set-TaskbarShowAppsFlashing -State $ShowAppsFlashing }
            'ShowOnAllDisplays'               { Set-TaskbarShowOnAllDisplays -State $ShowOnAllDisplays }
            'ShowOnAllDisplaysGPO'            { Set-TaskbarShowOnAllDisplays -GPO $ShowOnAllDisplaysGPO }
            'ShowAppsOnMultipleDisplays'      { Set-TaskbarShowAppsOnMultipleDisplays -Value $ShowAppsOnMultipleDisplays }
            'ShareAnyWindow'                  { Set-TaskbarShareAnyWindow -State $ShareAnyWindow }
            'FarCornerToShowDesktop'          { Set-TaskbarFarCornerToShowDesktop -State $FarCornerToShowDesktop }
            'GroupAndHideLabelsMainTaskbar'   { Set-TaskbarCombineButtonsAndHideLabels -MainTaskbar $GroupAndHideLabelsMainTaskbar }
            'GroupAndHideLabelsOtherTaskbars' { Set-TaskbarCombineButtonsAndHideLabels -OtherTaskbars $GroupAndHideLabelsOtherTaskbars }
            'GroupAndHideLabelsGPO'           { Set-TaskbarCombineButtonsAndHideLabels -GPO $GroupAndHideLabelsGPO }
            'ShowJumplistOnHover'             { Set-TaskbarShowJumplistOnHover -State $ShowJumplistOnHover }
        }
    }
}
