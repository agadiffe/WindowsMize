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

        foreach ($Scope in $GPRegistryFilePath.Keys)
        {
            lgpo.exe /parse /$Scope $GPRegistryFilePath[$Scope] /q | Out-File -FilePath $LgpoTxtFilePath

            $LgpoContent = Get-Content -Raw -Path $LgpoTxtFilePath
            $LgpoNewContent = $LgpoContent -replace '(?:.+\r?\n){3}DELETE'

            if ($LgpoNewContent -ne $LgpoContent)
            {
                $LgpoNewContent | Out-File -FilePath $LgpoTxtFilePath
                Write-Verbose -Message "Removing 'DELETE command(s)' from Registry Policy file: $($GPRegistryFilePath[$Scope])"
                lgpo.exe /r $LgpoTxtFilePath /w $GPRegistryFilePath[$Scope] /q
            }

            Remove-Item -Path $LgpoTxtFilePath
        }
    }
}
