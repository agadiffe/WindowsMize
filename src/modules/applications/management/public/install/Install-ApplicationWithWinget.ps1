#=================================================================================================================
#                                         Install Application With Winget
#=================================================================================================================

<#
.SYNTAX
    Install-ApplicationWithWinget
        [-Id] <string>
        [[-Scope] {Machine | User}]
        [<CommonParameters>]
#>

function Install-ApplicationWithWinget
{
    <#
    .EXAMPLE
        PS> Install-ApplicationWithWinget -Id 'VideoLAN.VLC' -Scope 'Machine'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Id,

        [ValidateSet('Machine', 'User')]
        [string] $Scope
    )

    process
    {
        Write-Verbose -Message "Installing $Id ..."

        $InstallOptions = @(
            '--exact'
            '--accept-source-agreements'
            '--accept-package-agreements'
            '--silent'
            '--disable-interactivity'
            '--source=winget'
        )

        if ($Scope)
        {
            $InstallOptions += "--scope=$Scope"
        }

        if ($Scope -eq 'User')
        {
            $UserName = (Get-LoggedOnUserInfo)['UserName']
            Install-AppWithWingetUserScheduledTask -Id $Id -RunAsUser $UserName -Argument $InstallOptions
        }
        else
        {
            winget.exe install --id $Id @InstallOptions
        }
    }
}
