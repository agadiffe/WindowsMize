#=================================================================================================================
#                                     Helper Function - Test Gpedit And Lgpo
#=================================================================================================================

<#
.SYNTAX
    Test-GpeditAndLgpo [<CommonParameters>]
#>

function Test-GpeditAndLgpo
{
    <#
    .EXAMPLE
        PS> Test-GpeditAndLgpo
    #>

    [CmdletBinding()]
    param ()

    process
    {
        $Gpedit = Get-Command -Name 'gpedit.msc' -ErrorAction 'SilentlyContinue'
        $Lgpo = Get-Command -Name 'lgpo.exe' -ErrorAction 'SilentlyContinue'

        $Gpedit -and $Lgpo ? $true : $false
    }
}
