#=================================================================================================================
#                                    Export Default System Drivers StartupType
#=================================================================================================================

function Export-DefaultSystemDriversStartupType
{
    $SystemDrivers = @{
        All     = @{
            LogFilePath = "$PSScriptRoot\..\..\..\..\log\windows_default_system_drivers_all.json"
            GetData     = 'Get-CimInstance -ClassName Win32_SystemDriver -Verbose:$false'
        }
        WinMize = @{
            LogFilePath = "$PSScriptRoot\..\..\..\..\log\windows_default_system_drivers_winmize.json"
            GetData     = '
                $SystemDriverFilter = "Name = ''$($SystemDriversList.Values.ServiceName -join "'' OR Name = ''")''"
                Get-CimInstance -ClassName Win32_SystemDriver -Filter $SystemDriverFilter -Verbose:$false'
        }
    }

    foreach ($Key in $SystemDrivers.Keys)
    {
        if (-not (Test-Path -Path $SystemDrivers.$Key.LogFilePath))
        {
            Write-Verbose -Message "Exporting Default System Drivers StartupType ($Key) ..."

            New-ParentPath -Path $SystemDrivers.$Key.LogFilePath

            (Invoke-Expression -Command $SystemDrivers.$Key.GetData) |
                ForEach-Object -Process {
                    $StartMode = $_.StartMode.Replace("Auto", "Automatic")
                    $NewProperties = @{
                        InputObject = $_
                        NotePropertyMembers = @{
                            ServiceName = $_.Name
                            StartupType = $StartMode
                            DefaultType = $StartMode
                        }
                    }
                    Add-Member @NewProperties -PassThru
                } |
                Sort-Object -Property 'DisplayName' |
                Select-Object -Property 'DisplayName', 'ServiceName', 'StartupType', 'DefaultType' |
                ConvertTo-Json |
                Out-File -FilePath $SystemDrivers.$Key.LogFilePath
        }
    }
}
