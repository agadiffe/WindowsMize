#=================================================================================================================
#                                              Disable GameBar Links
#=================================================================================================================

# Fix error if XBox GameBar is uninstalled.

<#
.SYNTAX
    Disable-GameBarLinks
        [-Reset]
        [<CommonParameters>]
#>

function Disable-GameBarLinks
{
    <#
    .EXAMPLE
        PS> Disable-GameBarLinks
    #>

    [CmdletBinding()]
    param
    (
        [switch] $Reset
    )

    process
    {
        $GamebarLinks = @(
            @{
                Hive    = 'HKEY_CLASSES_ROOT'
                Path    = 'ms-gamebar'
                Entries = @(
                    @{
                        Name  = '(Default)'
                        Value = 'URL:ms-gamebar'
                        Type  = 'String'
                    }
                    @{
                        Name  = 'URL Protocol'
                        Value = ''
                        Type  = 'String'
                    }
                    @{
                        RemoveEntry = $Reset
                        Name  = 'NoOpenWith'
                        Value = ''
                        Type  = 'String'
                    }
                )
            }
            @{
                RemoveKey = $Reset
                Hive    = 'HKEY_CLASSES_ROOT'
                Path    = 'ms-gamebar\shell\open\command'
                Entries = @(
                    @{
                        Name  = '(Default)'
                        Value = "$env:SystemRoot\System32\systray.exe"
                        Type  = 'String'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CLASSES_ROOT'
                Path    = 'ms-gamebarservices'
                Entries = @(
                    @{
                        Name  = '(Default)'
                        Value = 'URL:ms-gamebarservices'
                        Type  = 'String'
                    }
                    @{
                        Name  = 'URL Protocol'
                        Value = ''
                        Type  = 'String'
                    }
                    @{
                        RemoveEntry = $Reset
                        Name  = 'NoOpenWith'
                        Value = ''
                        Type  = 'String'
                    }
                )
            }
            @{
                RemoveKey = $Reset
                Hive    = 'HKEY_CLASSES_ROOT'
                Path    = 'ms-gamebarservices\shell\open\command'
                Entries = @(
                    @{
                        Name  = '(Default)'
                        Value = "$env:SystemRoot\System32\systray.exe"
                        Type  = 'String'
                    }
                )
            }
        )

        $GamebarLinksState = $Reset ? 'Resetting' : 'Disabling'
        Write-Verbose -Message "$GamebarLinksState 'GameBar Links (fix error if XBox GameBar is uninstalled)' ..."
        $GamebarLinks | Set-RegistryEntry
    }
}
