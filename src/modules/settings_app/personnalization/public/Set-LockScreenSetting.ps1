#=================================================================================================================
#                                    Personnalization > Lock Screen - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-LockScreenSetting
        [-SetToPicture]
        [-GetFunFactsTipsTricks {Disabled | Enabled}]
        [-ShowPictureOnSigninScreen {Disabled | Enabled}]
        [-ShowPictureOnSigninScreenGPO {Disabled | NotConfigured}]
        [-Widgets {Disabled | Enabled}]
        [-WidgetsGPO {Disabled | NotConfigured}]
        [-WidgetsSuggestion {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-LockScreenSetting
{
    <#
    .EXAMPLE
        PS> Set-LockScreenSetting -SetToPicture -GetFunFactsTipsTricks 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [switch] $SetToPicture,
        [state] $GetFunFactsTipsTricks,
        [state] $ShowPictureOnSigninScreen,
        [GpoStateWithoutEnabled] $ShowPictureOnSigninScreenGPO,
        [state] $Widgets,
        [GpoStateWithoutEnabled] $WidgetsGPO,
        [state] $WidgetsSuggestion
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
            'SetToPicture'                 { if ($SetToPicture) { Set-LockScreenToPicture } }
            'GetFunFactsTipsTricks'        { Set-LockScreenGetFunFactsTipsTricks -State $GetFunFactsTipsTricks }
            'ShowPictureOnSigninScreen'    { Set-LockScreenShowPictureOnSigninScreen -State $ShowPictureOnSigninScreen }
            'ShowPictureOnSigninScreenGPO' { Set-LockScreenShowPictureOnSigninScreen -GPO $ShowPictureOnSigninScreenGPO }
            'Widgets'                      { Set-LockScreenWidgets -State $Widgets }
            'WidgetsGPO'                   { Set-LockScreenWidgets -GPO $WidgetsGPO }
            'WidgetsSuggestion'            { Set-LockScreenWidgetsSuggestion -State $WidgetsSuggestion }
        }
    }
}
