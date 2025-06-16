#=================================================================================================================
#                            Microsoft Windows Malicious Software Removal Tool (MSRT)
#=================================================================================================================

function Remove-MSMaliciousSoftwareRemovalTool
{
    if (Get-Command -Name 'mrt.exe' -ErrorAction 'SilentlyContinue')
    {
        Write-Verbose -Message 'Removing Microsoft Windows Malicious Software Removal Tool (MSRT) ...'
        wusa.exe /uninstall /kb:890830 /quiet /norestart

        # gpo\ install with windows update
        # not configured: delete (default) | off: 1
        $MsrtWindowsUpdateGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\MRT'
            Entries = @(
                @{
                    Name  = 'DontOfferThroughWUAU'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }
        Set-RegistryEntry -InputObject $MsrtWindowsUpdateGpo -Verbose:$false
    }
    else
    {
        Write-Verbose -Message 'Microsoft Windows Malicious Software Removal Tool (MSRT) is not installed'
    }
}
