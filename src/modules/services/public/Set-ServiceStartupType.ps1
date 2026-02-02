#=================================================================================================================
#                                             Set Service StartupType
#=================================================================================================================

# Lower process count is not the only thing that matter.
# Two important metrics to also look at are 'Cycles Delta' and 'Context Switches Delta'.
# You can use 'Process Explorer' to check these metrics.

class ServiceStartupType
{
    [string] $DisplayName
    [string] $ServiceName
    [string] $StartupType
    [string] $DefaultType
    [string] $Comment
}

<#
.SYNTAX
    Set-ServiceStartupType
        [-InputObject] <ServiceStartupType>
        [-RestoreDefault]
        [<CommonParameters>]
#>

function Set-ServiceStartupType
{
    <#
    .EXAMPLE
        PS> $ServicesBackupFile = 'X:\Backup\windows_services_default.json'
        PS> $ServicesBackup = Get-Content -Raw -Path $ServicesBackupFile | ConvertFrom-Json
        PS> $ServicesBackup | Set-ServiceStartupType

    .EXAMPLE
        PS> $Xbox = '[
              {
                "DisplayName": "Xbox Live Game Save",
                "ServiceName": "XblGameSave",
                "StartupType": "Disabled",
                "DefaultType": "Manual",
                "Comment"    : "some comment"
              }
            ]' | ConvertFrom-Json
        PS> $Xbox | Set-ServiceStartupType
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ServiceStartupType] $InputObject,

        [switch] $RestoreDefault
    )

    begin
    {
        $RegistryStartValue = @{
            Boot                  = '0'
            System                = '1'
            AutomaticDelayedStart = '2'
            Automatic             = '2'
            Manual                = '3'
            Disabled              = '4'
        }

        $ServiceTemplate = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Services'
            Entries = @(
                @{
                    Name  = 'Start'
                    Value = ''
                    Type  = 'DWord'
                }
                @{
                    Name  = 'DelayedAutostart'
                    Value = ''
                    Type  = 'DWord'
                }
            )
        }
    }

    process
    {
        $Name = $InputObject.ServiceName
        $DisplayName = $InputObject.DisplayName
        $StartupType = $RestoreDefault ? $InputObject.DefaultType : $InputObject.StartupType

        $CurrentStartupType = (Get-Service -Name $Name -ErrorAction 'SilentlyContinue').StartType

        if (-not $CurrentStartupType)
        {
            Write-Verbose -Message "Service '$DisplayName ($Name)' not found"
        }
        elseif ($CurrentStartupType -eq $StartupType)
        {
            Write-Verbose -Message "'$DisplayName ($Name)' is already set to '$StartupType'"
        }
        else
        {
            Write-Verbose -Message "Setting '$DisplayName ($Name)' to '$StartupType' ..."

            # Some services cannot be changed:
            #   with services.msc (this include Set-Service) (grayed out or Access is denied).
            #   with registry editing (Access is denied).
            #   with neither services.msc or registry editing (Access is denied).
            #
            # "Access is denied" means that SYSTEM or TrustedInstaller privileges are required.
            try
            {
                Set-Service -Name $Name -StartType $StartupType -ErrorAction 'Stop'
            }
            catch
            {
                Write-Verbose -Message "    cannot be changed with 'Set-Service': using registry editing ..."

                $ServiceProperties = @{
                    Hive    = $ServiceTemplate.Hive
                    Path    = "$($ServiceTemplate.Path)\$Name"
                    Entries = $ServiceTemplate.Entries
                }
                $ServiceProperties.Entries[0].Value = $RegistryStartValue.$StartupType
                $ServiceProperties.Entries[1].Value = $StartupType -eq 'AutomaticDelayedStart' ? 1 : 0
                Set-RegistryEntry -InputObject $ServiceProperties -Verbose:$false
            }
        }
    }
}
