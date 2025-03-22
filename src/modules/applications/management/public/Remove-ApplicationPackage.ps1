#=================================================================================================================
#                                           Remove Application Package
#=================================================================================================================

<#
.SYNTAX
    Remove-ApplicationPackage
        [-Name] <string>
        [<CommonParameters>]
#>

function Remove-ApplicationPackage
{
    <#
    .EXAMPLE
        PS> Remove-ApplicationPackage -Name 'Microsoft.WindowsAlarms'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Name
    )

    begin
    {
        # "-PackageTypeFilter 'All'" also retrieves Provisionned packages
        $AllAppxPackages = Get-AppxPackage -AllUsers -PackageTypeFilter 'All' -Verbose:$false
    }

    process
    {
        $AppxPackagesName = ($AllAppxPackages | Where-Object -Property 'Name' -EQ -Value $Name).PackageFullName

        if ($AppxPackagesName)
        {
            Write-Verbose -Message "Removing $Name ..."

            # The progress bar of Remove-AppxPackage mess up the terminal rendering.
            # Use a PowerShell child process as workaround.
            powershell.exe -args $AppxPackagesName -NoProfile -Command {
                $args | Remove-AppxPackage -ErrorAction 'SilentlyContinue'
                $args | Remove-AppxPackage -AllUsers -ErrorAction 'SilentlyContinue'
            }
        }
        else
        {
            Write-Verbose -Message "$Name is not installed"
        }
    }
}
