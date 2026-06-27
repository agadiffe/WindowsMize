#=================================================================================================================
#                                      Personnalization > Taskbar - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarSetting
        # taskbar items
        [-SearchBox {Hide | IconOnly | Box | IconAndLabel}]
        [-SearchBoxGPO {Hide | IconOnly | Box | IconAndLabel | NotConfigured}]
        [-AskCopilot {Disabled | Enabled}]
        [-TaskView {Disabled | Enabled}]
        [-TaskViewGPO {Disabled | NotConfigured}]
        [-Widgets {Disabled | Enabled}]
        [-ResumeAppNotif {Disabled | Enabled}]

        # system tray icons
        [-EmojiAndMore {Never | WhileTyping | Always}]
        [-PenMenu {Disabled | Enabled}]
        [-TouchKeyboard {Never | Always | WhenNoKeyboard}]
        [-VirtualTouchpad {Disabled | Enabled}]

        # other system tray icons
        [-HiddenIconMenu {Disabled | Enabled}]

        # taskbar behaviors
        [-Position] {Left | Top | Right | Bottom}
        [-IconAlignment {Left | Center}]
        [-Size {Default | Small}]
        [-TouchOptimized {Disabled | Enabled}]
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
        [-ShowSmallerButtons {Always | Never | WhenFull}]
        [-ShowJumpListOnHover {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-TaskbarSetting
{
    <#
    .EXAMPLE
        PS> Set-TaskbarSetting -SearchBox 'Hide' -TaskView 'Disabled' -IconAlignment 'Center'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # taskbar items
        [SearchBoxMode] $SearchBox,
        [GpoSearchBoxMode] $SearchBoxGPO,
        [state] $AskCopilot,
        [state] $TaskView,
        [GpoStateWithoutEnabled] $TaskViewGPO,
        [state] $Widgets,
        [state] $ResumeAppNotif,

        # system tray icons
        [EmojiMode] $EmojiAndMore,
        [state] $PenMenu,
        [TouchKeyboardMode] $TouchKeyboard,
        [state] $VirtualTouchpad,

        # other system tray icons
        [state] $HiddenIconMenu,

        # taskbar behaviors
        [TaskbarPosition] $Position,
        [TaskbarAlignment] $IconAlignment,
        [TaskbarSize] $Size,
        [state] $TouchOptimized,
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
        [TaskbarSmallerButtonsMode] $ShowSmallerButtons,
        [state] $ShowJumpListOnHover
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
            # taskbar items
            'SearchBox'                       { Set-TaskbarSearchBox -Mode $SearchBox }
            'SearchBoxGPO'                    { Set-TaskbarSearchBox -GPO $SearchBoxGPO }
            'AskCopilot'                      { Set-TaskbarAskCopilot -State $AskCopilot }
            'TaskView'                        { Set-TaskbarTaskView -State $TaskView }
            'TaskViewGPO'                     { Set-TaskbarTaskView -GPO $TaskViewGPO }
            'Widgets'                         { Set-TaskbarWidgets -State $Widgets }
            'ResumeAppNotif'                  { Set-TaskbarResumeAppNotif -State $ResumeAppNotif }

            # system tray icons
            'EmojiAndMore'                    { Set-TaskbarEmojiAndMore -Visibility $EmojiAndMore }
            'PenMenu'                         { Set-TaskbarPenMenu -State $PenMenu }
            'TouchKeyboard'                   { Set-TaskbarTouchKeyboard -Visibility $TouchKeyboard }
            'VirtualTouchpad'                 { Set-TaskbarVirtualTouchpad -State $VirtualTouchpad }

            # other system tray icons
            'HiddenIconMenu'                  { Set-TaskbarHiddenIconMenu -State $HiddenIconMenu }

            # taskbar behaviors
            'Position'                        { Set-TaskbarPosition -Mode $Position }
            'IconAlignment'                   { Set-TaskbarIconAlignment -Mode $IconAlignment }
            'Size'                            { Set-TaskbarSize -Mode $Size }
            'TouchOptimized'                  { Set-TaskbarTouchOptimized -State $TouchOptimized }
            'AutoHide'                        { Set-TaskbarAutoHide -State $AutoHide }
            'ShowAppsBadges'                  { Set-TaskbarShowAppsBadges -State $ShowAppsBadges }
            'ShowAppsFlashing'                { Set-TaskbarShowAppsFlashing -State $ShowAppsFlashing }
            'ShowOnAllDisplays'               { Set-TaskbarShowOnAllDisplays -State $ShowOnAllDisplays }
            'ShowOnAllDisplaysGPO'            { Set-TaskbarShowOnAllDisplays -GPO $ShowOnAllDisplaysGPO }
            'ShowAppsOnMultipleDisplays'      { Set-TaskbarShowAppsOnMultipleDisplays -Mode $ShowAppsOnMultipleDisplays }
            'ShareAnyWindow'                  { Set-TaskbarShareAnyWindow -State $ShareAnyWindow }
            'FarCornerToShowDesktop'          { Set-TaskbarFarCornerToShowDesktop -State $FarCornerToShowDesktop }
            'GroupAndHideLabelsMainTaskbar'   { Set-TaskbarCombineButtonsAndHideLabels -MainTaskbar $GroupAndHideLabelsMainTaskbar }
            'GroupAndHideLabelsOtherTaskbars' { Set-TaskbarCombineButtonsAndHideLabels -OtherTaskbars $GroupAndHideLabelsOtherTaskbars }
            'GroupAndHideLabelsGPO'           { Set-TaskbarCombineButtonsAndHideLabels -GPO $GroupAndHideLabelsGPO }
            'ShowSmallerButtons'              { Set-TaskbarShowSmallerButtons -Preference $ShowSmallerButtons }
            'ShowJumpListOnHover'             { Set-TaskbarShowJumpListOnHover -State $ShowJumpListOnHover }
        }
    }
}
