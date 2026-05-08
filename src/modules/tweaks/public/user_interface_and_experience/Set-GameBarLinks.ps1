#=================================================================================================================
#                                                  GameBar Links
#=================================================================================================================

# Fix error if XBox GameBar is uninstalled.

<#
.SYNTAX
    Set-GameBarLinks
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-GameBarLinks
{
    <#
    .EXAMPLE
        PS> Set-GameBarLinks -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $IsEnabled = $State -eq 'Enabled'

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
                        RemoveEntry = $IsEnabled
                        Name  = 'NoOpenWith'
                        Value = ''
                        Type  = 'String'
                    }
                )
            }
            @{
                RemoveKey = $IsEnabled
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
                        RemoveEntry = $IsEnabled
                        Name  = 'NoOpenWith'
                        Value = ''
                        Type  = 'String'
                    }
                )
            }
            @{
                RemoveKey = $IsEnabled
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

        Write-Verbose -Message "Setting 'GameBar Links (fix error if XBox GameBar is uninstalled)' to '$State' ..."
        $GamebarLinks | Set-RegistryEntry
    }
}
