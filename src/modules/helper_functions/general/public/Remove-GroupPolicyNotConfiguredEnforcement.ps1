#=================================================================================================================
#                        Helper Function - Remove Group Policy Not-Configured Enforcement
#=================================================================================================================

<#
.SYNTAX
    Remove-GroupPolicyNotConfiguredEnforcement [<CommonParameters>]
#>

function Remove-GroupPolicyNotConfiguredEnforcement
{
    <#
    .DESCRIPTION
        Using LGPO to delete a registry value (reverting it to "NotConfigured") also inserts a command into the registry.pol file.
        This function remove all DELETE command(s).

    .EXAMPLE
        PS> Remove-GroupPolicyNotConfiguredEnforcement
    #>

    [CmdletBinding()]
    param ()

    process
    {
        if (-not (Test-GpeditAndLgpo))
        {
            return
        }

        $GPRegistryFilePath = @{
            u = "$env:SystemRoot\System32\GroupPolicy\User\Registry.pol"
            m = "$env:SystemRoot\System32\GroupPolicy\Machine\Registry.pol"
        }
        $LgpoTxtFilePath = "$([System.IO.Path]::GetTempPath())\lgpo_parse.txt"

        Write-Verbose -Message 'Removing ''DELETE command(s)'' from Registry Policy file ...'

        # Delay in case gpsvc (Group Policy Client service) still use the files.
        # A fix sleep might not be 100% reliable on slower hardware but 3 seconds should be more than enought.
        #
        # Related error:
        #  Unable to create output file:  C:\WINDOWS\System32\GroupPolicy\Machine\Registry.pol
        #  The process cannot access the file because it is being used by another process.
        #  (Error # 32 = 0x00000020)
        Start-Sleep -Seconds 3

        foreach ($Scope in $GPRegistryFilePath.Keys)
        {
            $GPRegPolFilePath = $GPRegistryFilePath[$Scope]

            if (Test-Path -Path $GPRegPolFilePath)
            {
                $StartProcessParam = @{
                    FilePath               = 'lgpo.exe'
                    ArgumentList           = "/parse /$Scope ""$GPRegPolFilePath"" /q"
                    RedirectStandardOutput = $LgpoTxtFilePath
                }
                Start-Process -Wait -NoNewWindow @StartProcessParam
                Start-Sleep -Seconds 0.1

                $LgpoContent = Get-Content -Raw -Path $LgpoTxtFilePath
                $LgpoNewContent = $LgpoContent -replace '(?:.+\r?\n){3}DELETE'

                if ($LgpoNewContent -ne $LgpoContent)
                {
                    $LgpoNewContent | Out-File -FilePath $LgpoTxtFilePath

                    Write-Verbose -Message "  '$GPRegPolFilePath': Processing ..."

                    $StartProcessParam = @{
                        FilePath     = 'lgpo.exe'
                        ArgumentList = "/r ""$LgpoTxtFilePath"" /w ""$GPRegPolFilePath"" /q"
                    }
                    Start-Process -Wait -NoNewWindow @StartProcessParam
                    Start-Sleep -Seconds 0.1
                }
                else
                {
                    Write-Verbose -Message "  '$GPRegPolFilePath': No command(s) to remove."
                }

                Remove-Item -Path $LgpoTxtFilePath
            }
        }
    }
}
