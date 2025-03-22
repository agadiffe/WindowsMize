#=================================================================================================================
#                                       Export Default Services StartupType
#=================================================================================================================

function Export-DefaultServicesStartupType
{
    $Services = @{
        All     = @{
            LogFilePath = "$PSScriptRoot\..\..\..\..\log\windows_default_services_all.json"
            GetData     = 'Get-Service -ErrorAction SilentlyContinue'
        }
        WinMize = @{
            LogFilePath = "$PSScriptRoot\..\..\..\..\log\windows_default_services_winmize.json"
            GetData     = '$ServicesList.Values |
                ForEach-Object -Process {
                    Get-Service -Name $_.ServiceName -ErrorAction SilentlyContinue
                }'
        }
    }

    foreach ($Key in $Services.Keys)
    {
        if (-not (Test-Path -Path $Services.$Key.LogFilePath))
        {
            Write-Verbose -Message "Exporting Default Services StartupType ($Key) ..."
    
            $CurrentLUID = (Get-Service -Name 'WpnUserService_*').Name.Replace('WpnUserService', '')
            ((Invoke-Expression -Command $Services.$Key.GetData) |
                ForEach-Object -Process {
                    $NewProperty = @{
                        InputObject       = $_
                        NotePropertyName  = 'DefaultType'
                        NotePropertyValue = $_.StartupType
                    }
                    Add-Member @NewProperty -PassThru
                } |
                Sort-Object -Property 'DisplayName' |
                Select-Object -Property 'DisplayName', 'ServiceName', 'StartupType', 'DefaultType' |
                ConvertTo-Json -EnumsAsStrings).Replace($CurrentLUID, '') |
                Out-File -FilePath $Services.$Key.LogFilePath
        }
    }
}
