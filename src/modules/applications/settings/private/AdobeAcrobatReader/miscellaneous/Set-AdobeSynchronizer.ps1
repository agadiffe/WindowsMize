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
                $AdobeFullTrustNotifierFilePath = "$($AdobeAcrobatInfo.InstallLocation)\Acrobat\RDCNotificationClient\FullTrustNotifier.exe"

                Write-Verbose -Message "Setting 'Adobe Synchronizer Task Manager Process' to '$TaskManagerProcess' ..."

                switch ($TaskManagerProcess)
                {
                    'Disabled'
                    {
                        $AdobeSynchronizerFilePath, $AdobeFullTrustNotifierFilePath |
                            ForEach-Object -Process {
                                if (Test-Path $_)
                                {
                                    Write-Verbose -Message "    Rename '$_' to '$_.bak'"
                                    Move-Item -Force -Path $_ -Destination "$_.bak"
                                }
                                else
                                {
                                    Write-Verbose -Message "    Already disabled: '$_' not found"
                                }
                            }
                    }
                    'Enabled'
                    {
                        $AdobeSynchronizerFilePath, $AdobeFullTrustNotifierFilePath |
                            ForEach-Object -Process {
                                if (Test-Path $_)
                                {
                                    Write-Verbose -Message "    Already enabled: '$_' found"
                                }
                                elseif (Test-Path "$_.bak")
                                {
                                    Write-Verbose -Message "    Rename '$_.bak' to '$_'"
                                    Move-Item -Path "$_.bak" -Destination $_
                                }
                                else
                                {
                                    Write-Error -Message ("    Error occured: '$_' and its backup file not found.`n" +
                                        "                 Repair or reinstall Adobe Acrobat.")
                                }
                            }
                    }
                }
            }
        }
    }
}
