#=================================================================================================================
#                                      Helper Function - Set Registry Entry
#=================================================================================================================

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
        PS> $Foo = @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\FooApp\Config'
                Entries = @(
                    @{
                        Name  = 'Enabled'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $true
                        Name  = 'Autostart'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
        PS> Set-RegistryEntry -InputObject $Foo

    .EXAMPLE
        PS> $Bar = '[
                {
                    "SkipKey" : true,
                    "Hive"    : "HKEY_LOCAL_MACHINE",
                    "Path"    : "SOFTWARE\\FooApp\\Config",
                    "Entries" : []
                },
                {
                    "RemoveKey" : true,
                    "Hive"    : "HKEY_LOCAL_MACHINE",
                    "Path"    : "SOFTWARE\\BarApp\\Config",
                    "Entries" : []
                }
            ]' | ConvertFrom-Json
        PS> $Bar | Set-RegistryEntry
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [RegistryEntry] $InputObject
    )

    begin
    {
        $UserSid = (Get-LoggedOnUserInfo)['Sid']
    }

    process
    {
        if ($InputObject.SkipKey)
        {
            return
        }

        $RegistryPath = "$($InputObject.Hive)\$($InputObject.Path)" -replace '\\+', '\'
        $RegistryPathOriginal = $RegistryPath

        if ($InputObject.Hive -eq 'HKEY_CURRENT_USER')
        {
            $RegistryPath = $RegistryPath -ireplace '^HKEY_CURRENT_USER', "HKEY_USERS\$UserSid"
        }

        $RegistryPath = "Registry::$RegistryPath"
        if ($InputObject.RemoveKey)
        {
            Write-Verbose -Message "  remove: $RegistryPathOriginal"
            Remove-Item -Recurse -Path $RegistryPath -ErrorAction 'SilentlyContinue'
        }
        else
        {
            Write-Verbose -Message "      key: $RegistryPathOriginal"

            if (-not (Test-Path -Path $RegistryPath))
            {
                New-Item -Path $RegistryPath -Force | Out-Null
            }

            foreach ($Entry in $InputObject.Entries)
            {
                if ($Entry.RemoveEntry)
                {
                    Write-Verbose -Message "   remove: '$($Entry.Name)'"
                    Remove-ItemProperty -Path $RegistryPath -Name $Entry.Name -ErrorAction 'SilentlyContinue'
                }
                else
                {
                    Write-Verbose -Message "      set: '$($Entry.Name)' to '$($Entry.Value)' ($($Entry.Type))"
                    Set-ItemProperty -Path $RegistryPath -Name $Entry.Name -Value $Entry.Value -Type $Entry.Type | Out-Null
                }
            }
        }

        Sync-GroupPolicySetting -InputObject $InputObject
    }
}
