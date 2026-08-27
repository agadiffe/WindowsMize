#=================================================================================================================
#                                    Personnalization > Lock Screen - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-ContextMenuSetting
        [-SendTo {Disabled | Enabled}]
        [-Print {Disabled | Enabled}]
        [-CreateShortcut {Disabled | Enabled}]
        [-CopyAsPath {Disabled | Enabled}]
        [-RotateImage {Disabled | Enabled}]
        [-AppExtensionsSubmenu {Disabled | Enabled}]
        [-PrimaryActionsInline {Disabled | Enabled}]
        [-CloudStorageSection {Disabled | Enabled}]
        [-ShowMoreOptions {Disabled | Enabled}]
        [-MovePropertiesToBottom {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-ContextMenuSetting
{
    <#
    .EXAMPLE
        PS> Set-ContextMenuSetting -SendTo 'Disabled' -CopyAsPath 'Enabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $SendTo,
        [state] $Print,
        [state] $CreateShortcut,
        [state] $CopyAsPath,
        [state] $RotateImage,
        [state] $AppExtensionsSubmenu,
        [state] $PrimaryActionsInline,
        [state] $CloudStorageSection,
        [state] $ShowMoreOptions,
        [state] $MovePropertiesToBottom
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
            'SendTo'                 { Set-ContextMenuSendTo -State $SendTo }
            'Print'                  { Set-ContextMenuPrint -State $Print }
            'CreateShortcut'         { Set-ContextMenuCreateShortcut -State $CreateShortcut }
            'CopyAsPath'             { Set-ContextMenuCopyAsPath -State $CopyAsPath }
            'RotateImage'            { Set-ContextMenuRotateImage -State $RotateImage }
            'AppExtensionsSubmenu'   { Set-ContextMenuAppExtensionsSubmenu -State $AppExtensionsSubmenu }
            'PrimaryActionsInline'   { Set-ContextMenuPrimaryActionsInline -State $PrimaryActionsInline }
            'CloudStorageSection'    { Set-ContextMenuCloudStorageSection -State $CloudStorageSection }
            'ShowMoreOptions'        { Set-ContextMenuShowMoreOptions -State $ShowMoreOptions }
            'MovePropertiesToBottom' { Set-ContextMenuMovePropertiesToBottom -State $MovePropertiesToBottom }
        }
    }
}
