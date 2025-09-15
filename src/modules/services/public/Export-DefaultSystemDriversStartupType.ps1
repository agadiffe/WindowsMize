#=================================================================================================================
#                                    Export Default System Drivers StartupType
#=================================================================================================================

<#
.SYNTAX
    Export-DefaultSystemDriversStartupType [<CommonParameters>]
#>

function Export-DefaultSystemDriversStartupType
{
    [CmdletBinding()]
    param ()

    process
    {
        $LogFilePath = "$(Get-LogPath)\windows_default_system_drivers_winmize.json"

        if (-not (Test-Path -Path $LogFilePath))
        {
            Write-Verbose -Message "Exporting Default System Drivers StartupType ($Key) ..."

            New-ParentPath -Path $LogFilePath

            Get-Service -Name $SystemDriversList.Values.ServiceName -ErrorAction 'SilentlyContinue' |
                ForEach-Object -Process {
                    $_.StartupType = $_.StartType
                    $NewProperty = @{
                        InputObject       = $_
                        NotePropertyName  = 'DefaultType'
                        NotePropertyValue = $_.StartType
                    }
                    Add-Member @NewProperty -PassThru
                } |
                Sort-Object -Property 'DisplayName' |
                Select-Object -Property 'DisplayName', 'ServiceName', 'StartupType', 'DefaultType' |
                ConvertTo-Json -EnumsAsStrings |
                Out-File -FilePath $LogFilePath
        }
    }
}
