#=================================================================================================================
#                                              Disable GameBar Links
#=================================================================================================================

# Fix error if XBox GameBar is uninstalled.

<#
.SYNTAX
    Disable-GameBarLinks [<CommonParameters>]
#>

function Disable-GameBarLinks
{
    <#
    .EXAMPLE
        PS> Disable-GameBarLinks
    #>

    [CmdletBinding()]
    param ()

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
                        Name  = 'NoOpenWith'
                        Value = ''
                        Type  = 'String'
                    }
                )
            }
            @{
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
                        Name  = 'NoOpenWith'
                        Value = ''
                        Type  = 'String'
                    }
                )
            }
            @{
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

        Write-Verbose -Message "Disabling GameBar Links (fix error if XBox GameBar is uninstalled)' ..."
        $GamebarLinks | Set-RegistryEntry
    }
}
