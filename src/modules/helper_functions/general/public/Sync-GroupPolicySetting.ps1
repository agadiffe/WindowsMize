#=================================================================================================================
#                                   Helper Function - Sync Group Policy Setting
#=================================================================================================================

# "C:\Windows\System32\GroupPolicy\User\Registry.pol"
# "C:\Windows\System32\GroupPolicy\Machine\Registry.pol"

<#
.SYNTAX
    Sync-GroupPolicySetting
        [-InputObject] <RegistryEntry>
        [<CommonParameters>]
#>

function Sync-GroupPolicySetting
{
    <#
    .DESCRIPTION
        Sync registry entries to the registry.pol file so they appear in the Group Policy Editor.
        Requires LGPO: winget install Microsoft.SecurityComplianceToolkit.LGPO

    .EXAMPLE
        PS> $Foo = @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\FooApp\Config'
                Entries = @(
                    @{
                        Name  = 'Enabled'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
        PS> Sync-GroupPolicySetting -InputObject $Foo
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [RegistryEntry] $InputObject
    )

    process
    {
        if (-not (Test-GpeditAndLgpo))
        {
            return
        }

        if (-not $Global:GroupPolicyAdmxData)
        {
            $Global:GroupPolicyAdmxData = Get-GroupPolicyAdmxData
        }

        $RegistryPath = ("$($InputObject.Hive)\$($InputObject.Path)" -replace '\\+', '\').TrimEnd('\')

        if (-not $Global:GroupPolicyAdmxData[$RegistryPath])
        {
            return
        }

        $LgpoScope = $InputObject.Hive -eq 'HKEY_LOCAL_MACHINE' ? 'Computer' : 'User'

        if ($InputObject.RemoveKey)
        {
            $PolicySetting = "
                $LgpoScope
                $($InputObject.Path)
                *
                CLEAR
            " -replace '(?m)^ +'
        }
        else
        {
            $LgpoType = @{
                String       = 'SZ'
                ExpandString = 'EXSZ'
                MultiString  = 'MULTISZ'
                Binary       = 'BINARY'
                DWord        = 'DWORD'
                QWord        = 'QWORD'
            }

            foreach ($Entry in $InputObject.Entries)
            {
                if ($Global:GroupPolicyAdmxData[$RegistryPath][$Entry.Name])
                {
                    if ($Entry.RemoveEntry)
                    {
                        $PolicySetting += "
                            $LgpoScope
                            $($InputObject.Path)
                            $($Entry.Name)
                            DELETE
                        " -replace '(?m)^ +'
                    }
                    else
                    {
                        $RegValue = $Entry.Value
                        if ($RegValue)
                        {
                            switch ($Entry.Type)
                            {
                                'Binary'
                                {
                                    $RegValue = ($RegValue | ForEach-Object -Process { $_.ToString('x2') }) -join ','
                                }
                                'MultiString'
                                {
                                    $RegValue = $RegValue.ForEach({ ConvertTo-LgpoEscapedString -String $_ }) -join '\0'
                                }
                                { $_ -eq 'String' -or $_ -eq 'ExpandString' }
                                {
                                    $RegValue = ConvertTo-LgpoEscapedString -String $RegValue
                                }
                            }
                        }

                        $PolicySetting += "
                            $LgpoScope
                            $($InputObject.Path)
                            $($Entry.Name)
                            $($LgpoType[$Entry.Type]):$RegValue
                        " -replace '(?m)^ +'
                    }
                }
            }
        }

        if ($PolicySetting)
        {
            $LgpoTxtFilePath = "$([System.IO.Path]::GetTempPath())\lgpo.txt"
            $PolicySetting | Out-File -FilePath $LgpoTxtFilePath

            Write-Verbose -Message '    update Registry Policy file.'
            Start-Process -Wait -NoNewWindow -FilePath 'lgpo.exe' -ArgumentList "/t ""$LgpoTxtFilePath"" /q"

            Remove-Item -Path $LgpoTxtFilePath
        }
    }
}

function ConvertTo-LgpoEscapedString
{
    <#
    .EXAMPLE
        PS> $x = "Hello
            World"
        PS> ConvertTo-LgpoEscapedString -String $x
        Hello\n    World
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $String
    )

    process
    {
        $String -replace '\\', '\\' -replace '\r', '\r' -replace '\n', '\n'
    }
}
