#=================================================================================================================
#                                    Personnalization > Lock Screen - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-LockScreenSetting
        [-SetToPicture]
        [-GetFunFactsTipsTricks {Disabled | Enabled}]
        [-ShowPictureOnSigninScreenGPO {Disabled | NotConfigured}]
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

        [GpoStateWithoutEnabled] $ShowPictureOnSigninScreenGPO
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
            'ShowPictureOnSigninScreenGPO' { Set-LockScreenShowPictureOnSigninScreen -GPO $ShowPictureOnSigninScreenGPO }
        }
    }
}
