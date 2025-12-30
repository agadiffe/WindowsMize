#=================================================================================================================
#                                 Helper Function - Test PowerShell LanguageMode
#=================================================================================================================

<#
.SYNTAX
    Test-PowerShellLanguageMode [<CommonParameters>]
#>

function Test-PowerShellLanguageMode
{
    <#
    .EXAMPLE
        PS> Test-PowerShellLanguageMode
    #>

    [CmdletBinding()]
    param ()

    process
    {
        if ($ExecutionContext.SessionState.LanguageMode -ne "FullLanguage")
        {
            Write-Error -Message 'The script cannot be run: LanguageMode is set to ConstrainedLanguage.'
            exit
        }
    }
}
