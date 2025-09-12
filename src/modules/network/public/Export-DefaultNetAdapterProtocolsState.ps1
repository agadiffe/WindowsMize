#=================================================================================================================
#                           Network Adapter - Export Default NetAdapter Protocols State
#=================================================================================================================

<#
.SYNTAX
    Export-DefaultNetAdapterProtocolsState [<CommonParameters>]
#>

function Export-DefaultNetAdapterProtocolsState
{
    [CmdletBinding()]
    param ()

    process
    {
        $LogFilePath = "$(Get-LogPath)\windows_default_netadapter_protocols_state.json"
        if (-not (Test-Path -Path $LogFilePath))
        {
            Write-Verbose -Message 'Exporting Default Network Adapter Protocols State ...'

            New-ParentPath -Path $LogFilePath

            Get-NetAdapterBinding |
                Group-Object -Property 'Name' |
                ForEach-Object -Process {
                    $ProtocolsDictionary = [ordered]@{}
                    $_.Group |
                        Sort-Object -Property 'DisplayName' |
                        ForEach-Object -Process {
                            $ProtocolState = $_.Enabled ? 'Enabled' : 'Disabled'
                            $ProtocolsDictionary.$($_.DisplayName) = $ProtocolState
                        }

                    [ordered]@{
                        NetAdapter = $_.Name
                        Protocol   = $ProtocolsDictionary
                    }
                } |
                ConvertTo-Json |
                Out-File -FilePath $LogFilePath
        }
    }
}
