#=================================================================================================================
#                               Acrobat Reader - Miscellaneous > Adobe Synchronizer
#=================================================================================================================

<#
.SYNTAX
    Set-AdobeSynchronizer
        [-RunAtStartup {Disabled | Enabled}]
        [-TaskManagerProcess {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-AdobeSynchronizer
{
    <#
    .EXAMPLE
        PS> Set-AdobeSynchronizer -RunAtStartup 'Disabled' -TaskManagerProcess 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $RunAtStartup,

        [state] $TaskManagerProcess
    )

    process
    {
        $AdobeAcrobatInfo = Get-ApplicationInfo -Name 'Adobe Acrobat*'
        if (-not $AdobeAcrobatInfo)
        {
            Write-Verbose -Message 'Adobe Acrobat is not installed'
            return
        }

        $AdobeSynchronizerFilePath = "$($AdobeAcrobatInfo.InstallLocation)\Acrobat\AdobeCollabSync.exe"
        $AdobeFullTrustNotifierFilePath = "$($AdobeAcrobatInfo.InstallLocation)\Acrobat\RDCNotificationClient\FullTrustNotifier.exe"

        switch ($PSBoundParameters.Keys)
        {
            'RunAtStartup'
            {
                # Adobe default installation may create 2 instances ...
                # on: not-delete | off: delete
                $AdobeSynchronizerRunAtStartup = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Run'
                    Entries = @(
                        @{
                            RemoveEntry = $RunAtStartup -eq 'Disabled'
                            Name  = 'Adobe Acrobat Synchronizer'
                            Value = $AdobeSynchronizerFilePath
                            Type  = 'String'
                        }
                        @{
                            RemoveEntry = $true
                            Name  = 'Adobe Reader Synchronizer'
                            Value = $AdobeSynchronizerFilePath
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Adobe Synchronizer Run At Startup' to '$RunAtStartup' ..."
                Set-RegistryEntry -InputObject $AdobeSynchronizerRunAtStartup
            }
            'TaskManagerProcess'
            {
                Write-Verbose -Message "Setting 'Adobe Synchronizer Task Manager Process' to '$TaskManagerProcess' ..."

                $ProcessNames = 'AdobeCollabSync', 'FullTrustNotifier'
                Stop-Process -Name $ProcessNames -Force -ErrorAction 'SilentlyContinue'
                Wait-Process -Name $ProcessNames -ErrorAction 'SilentlyContinue'
                Start-Sleep -Seconds 0.3

                $Sid = 'S-1-1-0' # 'EVERYONE' group
                $AdobeSynchronizerFilePath, $AdobeFullTrustNotifierFilePath | ForEach-Object -Process {
                    if (Test-Path -Path $_)
                    {
                        if ($TaskManagerProcess -eq 'Enabled')
                        {
                            Set-FileSystemAccessRule -Path $_ -Sid $Sid -RemoveAll
                        }
                        else
                        {
                            Set-FileSystemAccessRule -Path $_ -Sid $Sid -Permission 'Deny' -Access 'ExecuteFile'
                        }
                    }
                }
            }
        }
    }
}
