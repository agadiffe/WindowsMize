#=================================================================================================================
#                                               Install Application
#=================================================================================================================

class AppsList : System.Management.Automation.IValidateSetValuesGenerator
{
    [string[]] GetValidValues()
    {
        return $Script:AppsList.Keys
    }
}

<#
.SYNTAX
    Install-Application
        [-Name] {Git | VSCode | VLC | Bitwarden | KeePassXC | ProtonPass | AcrobatReader | SumatraPDF | 7zip |
                 Notepad++ | qBittorrent | Brave | Firefox | MullvadBrowser | DirectXEndUserRuntime |
                 VCRedist2015+.ARM | VCRedist2015+ | VCRedist2013 | VCRedist2012 | VCRedist2010 | VCRedist2008 |
                 VCRedist2005}
        [<CommonParameters>]
#>

function Install-Application
{
    <#
    .EXAMPLE
        PS> Install-Application -Name 'VLC'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateSet([AppsList])]
        [string] $Name
    )

    begin
    {
        # Manifest doesn't have 'Machine' scope.
        $UserScope = @(
            'ProtonPass'
            'MullvadBrowser'
        )

        # Manifest doesn't have 'User' or 'Machine' scope.
        $NoScope = @(
            'DirectXEndUserRuntime'
        )
    }

    process
    {
        switch ($Name)
        {
            'Brave'                     { Install-BraveBrowser }
            { $NoScope -contains $_ }   { $AppsList.$_ | Install-ApplicationWithWinget }
            { $UserScope -contains $_ } { $AppsList.$_ | Install-ApplicationWithWinget -Scope 'User' }
            Default                     { $AppsList.$_ | Install-ApplicationWithWinget -Scope 'Machine' }
        }
    }
}
