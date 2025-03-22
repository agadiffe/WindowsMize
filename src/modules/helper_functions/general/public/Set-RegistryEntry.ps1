#=================================================================================================================
#                                      Helper Function - Set Registry Entry
#=================================================================================================================

class RegistryEntry
{
    [bool] $SkipKey
    [bool] $RemoveKey
    [string] $Hive
    [string] $Path
    [RegistryKeyEntry[]] $Entries
}

class RegistryKeyEntry
{
    [bool] $RemoveEntry
    [string] $Name
    [string] $Value
    [string] $Type
}

<#
.SYNTAX
    Set-RegistryEntry
        [-InputObject] <RegistryEntry>
        [<CommonParameters>]
#>

function Set-RegistryEntry
{
    <#
    .EXAMPLE
        PS> $Foo = @(
                @{
                    Hive    = 'HKEY_LOCAL_MACHINE',
                    Path    = 'SOFTWARE\FooApp\Config',
                    Entries = @(
                        @{
                            Name  = 'Enabled',
                            Value = '1',
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $true,
                            Name  = 'Autostart',
                            Value = '1',
                            Type  = 'DWord'
                        }
                    )
                }
            )
        PS> Set-RegistryEntry -InputObject $Foo

    .EXAMPLE
        PS> $Bar = '[
                {
                    "SkipKey" : true,
                    "Hive"    : "HKEY_LOCAL_MACHINE",
                    "Path"    : "SOFTWARE\\BarApp\\Config",
                    "Entries" : [
                        {
                            "Name"  : "Enabled",
                            "Value" : "1",
                            "Type"  : "DWord"
                        }
                    ]
                },
                {
                    "RemoveKey" : true,
                    "Hive"    : "HKEY_LOCAL_MACHINE",
                    "Path"    : "SOFTWARE\\BarApp\\Config",
                    "Entries" : [
                        {
                            "Name"  : "Autostart",
                            "Value" : "1",
                            "Type"  : "DWord"
                        }
                    ]
                }
            ]' | ConvertFrom-Json
        PS> $FooBar = @(
                $Foo
                $Bar
            )
        PS> $FooBar | Set-RegistryEntry
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [RegistryEntry] $InputObject
    )

    begin
    {
        $UserSID = Get-LoggedOnUserSID
    }

    process
    {
        if ($InputObject.SkipKey)
        {
            return
        }

        $RegistryPath = ($InputObject.Hive + '\' + $InputObject.Path) -replace '\\+', '\'
        $RegistryPathOriginal = $RegistryPath

        if ($RegistryPath -match '^(?:HKCU|HKEY_CURRENT_USER)')
        {
            $RegistryPath = $RegistryPath -ireplace '^(?:HKCU|HKEY_CURRENT_USER)', "HKEY_USERS\$UserSID"
        }

        $RegistryPath = "Registry::$RegistryPath"
        if ($InputObject.RemoveKey)
        {
            Write-Verbose -Message "Removing key: $RegistryPathOriginal"
            Remove-Item -Recurse -Path $RegistryPath -ErrorAction 'SilentlyContinue'
        }
        else
        {
            Write-Verbose -Message "Setting key: $RegistryPathOriginal"

            if (-not (Test-Path -PathType 'Container' -Path $RegistryPath))
            {
                New-Item -Path $RegistryPath -Force | Out-Null
            }

            foreach ($Entry in $InputObject.Entries)
            {
                if ($Entry.RemoveEntry)
                {
                    Write-Verbose -Message "     remove: '$($Entry.Name)'"
                    Remove-ItemProperty -Path $RegistryPath -Name $Entry.Name -ErrorAction 'SilentlyContinue'
                }
                else
                {
                    $RegistryEntryData = @{
                        Path  = $RegistryPath
                        Name  = $Entry.Name
                        Value = $Entry.Value
                        Type  = $Entry.Type
                    }
                    if ($Entry.Type -eq 'Binary')
                    {
                        $RegistryEntryData.Value = $Entry.Value -eq '' ? $null : $Entry.Value -split '\s+'
                    }
                    Write-Verbose -Message "        set: '$($Entry.Name)' to '$($Entry.Value)' ($($Entry.Type))"
                    Set-ItemProperty @RegistryEntryData | Out-Null
                }
            }
        }
    }
}
