#=================================================================================================================
#                                         Install Application With Winget
#=================================================================================================================

<#
.SYNTAX
    Install-ApplicationWithWinget
        [-Name] <string>
        [[-Scope] {Machine | User}]
        [<CommonParameters>]
#>

function Install-ApplicationWithWinget
{
    <#
    .EXAMPLE
        PS> Install-ApplicationWithWinget -Name 'VideoLAN.VLC' -Scope 'Machine'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Name,

        [ValidateSet('Machine', 'User')]
        [string] $Scope
    )

    process
    {
        Write-Verbose -Message "Installing $Name ..."

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
        winget.exe install --id $Name @InstallOptions
    }
}
