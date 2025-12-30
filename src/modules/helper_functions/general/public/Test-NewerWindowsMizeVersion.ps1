#=================================================================================================================
#                                Helper Function - Test Newer WindowsMize Version
#=================================================================================================================

<#
.SYNTAX
    Test-NewerWindowsMizeVersion [<CommonParameters>]
#>

function Test-NewerWindowsMizeVersion
{
    <#
    .EXAMPLE
        PS> Test-NewerWindowsMizeVersion
    #>

    [CmdletBinding()]
    param ()

    process
    {
        $LatestVersionID = try {
            [version](Invoke-RestMethod -Uri 'https://github.com/agadiffe/WindowsMize/raw/main/VERSION_ID' -Verbose:$false)
        }
        catch
        {
            $null
        }
        $CurrentVersionID = [version](Get-Content -Raw -Path "$PSScriptRoot\VERSION_ID" -ErrorAction 'SilentlyContinue')

        if ($CurrentVersionID -and $CurrentVersionID -lt $LatestVersionID)
        {
            Write-Error -Message ('A newer version is available. Download it at https://github.com/agadiffe/WindowsMize. ' +
                'To run this version anyway, delete the file VERSION_ID.')
            exit
        }
    }
}
