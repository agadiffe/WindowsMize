#=================================================================================================================
#                                       Install Windows Subsystem For Linux
#=================================================================================================================

<#
.SYNTAX
    Install-WindowsSubsystemForLinux
        [[-Distribution] <string>]
        [<CommonParameters>]
#>

function Install-WindowsSubsystemForLinux
{
    <#
    .DESCRIPTION
        Install WSL and the default Ubuntu distribution of Linux.
        You can also use the '-Distribution' parameter to change the installed Linux distribution.

        Run 'wsl.exe --list --online' to see a list of available distros.

    .EXAMPLE
        PS> Install-WindowsSubsystemForLinux -Distribution 'Debian'
    #>

    [CmdletBinding()]
    param
    (
        [string] $Distribution
    )

    process
    {
        Write-Verbose -Message 'Installing Windows Subsystem For Linux ...'

        $InstallOptions = @(
            '--no-launch'
        )

        if ($Distribution)
        {
            $InstallOptions += "--distribution $Distribution"
        }
        wsl.exe --install @InstallOptions
    }
}
