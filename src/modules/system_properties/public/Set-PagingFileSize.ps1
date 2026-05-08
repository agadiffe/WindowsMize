#=================================================================================================================
#                     System Properties - Advanced > Performance > Advanced > Virtual Memory
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

# A paging file is an area on the hard disk that Windows uses as if it were RAM.

# automatically manage paging file size for all drives
#-------------------
# default: Enabled

# custom paging file size
#-------------------
# Depends on how much RAM you have:
#   20GB+: 512/512 for safeguard and (very) old programs that needs pagefile.
#   8-16GB: 2048/2048 should be enought, safeguard in case you eat up all ram.
#   4GB: 4096/4096 should be enought (if not enought, consider to upgrade your physical RAM if possible).


<#
.SYNTAX
    Set-PagingFileSize
        [-Drive] <string[]>
        [-Management] {CustomSize | SystemManaged | NoPagingFile}
        -InitialSizeMB <int>
        -MaximumSizeMB <int>
        [<CommonParameters>]

    Set-PagingFileSize
        -AutoManageAllDrives {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-PagingFileSize
{
    <#
    .DESCRIPTION
        Dynamic parameters:
            -InitialSizeMB <int> & -MaximumSizeMB <int> : available when 'Management' is defined to 'CustomSize'.

    .EXAMPLE
        PS> Set-PagingFileSize -Drive $env:SystemDrive -Management 'CustomSize' -InitialSizeMB 512 -MaximumSizeMB 2048

    .EXAMPLE
        PS> Set-PagingFileSize -Drive 'X:', 'Y:' -Management 'NoPagingFile'
    #>

    [CmdletBinding(DefaultParameterSetName = 'Management')]
    param
    (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Management')]
        [ValidatePattern(
            '^[A-Za-z]:\\?$',
            ErrorMessage = 'Drive format must be a letter followed by a colon, ' +
                           'optionally with a backslash (e.g. ''C:'' or ''C:\'').')]
        [ValidateScript(
            { Test-Path -Path $_ },
            ErrorMessage = 'The specified drive does not exist or is not accessible.')]
        [string[]] $Drive,

        [Parameter(Mandatory, Position = 1, ParameterSetName = 'Management')]
        [ValidateSet('CustomSize', 'SystemManaged', 'NoPagingFile')]
        [string] $Management,

        [Parameter(Mandatory, ParameterSetName = 'AutoManageAllDrives')]
        [state] $AutoManageAllDrives
    )

    dynamicparam
    {
        if ($Management -eq 'CustomSize')
        {
            $DynParameter = 'InitialSizeMB', 'MaximumSizeMB'

            $ParamDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
            $DynParameter | ForEach-Object -Process {
                $DynamicParamProperties = @{
                    Dictionary = $ParamDictionary
                    Name       = $_
                    Type       = [int]
                    Attribute  = @{
                        Parameter     = @{ Mandatory = $true; ParameterSetName = 'Management' }
                        ValidateRange = 'NonNegative'
                    }
                }
                Add-DynamicParameter @DynamicParamProperties
            }
            $ParamDictionary
        }
    }

    process
    {
        if ($Management -eq 'CustomSize')
        {
            $AutoManageAllDrives = 'Disabled'
            $InitialSizeMB = $PSBoundParameters['InitialSizeMB']
            $MaximumSizeMB = $PSBoundParameters['MaximumSizeMB']

            if ($MaximumSizeMB -lt $InitialSizeMB)
            {
                Write-Error -Message 'MaximumSizeMB must be greater than or equal to InitialSizeMB.'
                return
            }
        }

        Write-Verbose -Message "Setting 'All Drives AutoManaged Paging File Size' to '$AutoManageAllDrives'"

        $ComputerSystem = Get-CimInstance -ClassName 'Win32_ComputerSystem' -Verbose:$false
        $ComputerSystem.AutomaticManagedPagefile = $AutoManageAllDrives -eq 'Enabled'
        Set-CimInstance -InputObject $ComputerSystem -Verbose:$false

        if ($PSCmdlet.ParameterSetName -eq 'Management')
        {
            $ManagementMsg = $Management -eq 'CustomSize' ? "$InitialSizeMB MB / $MaximumSizeMB MB" : $Management

            foreach ($DriveLetter in $Drive)
            {
                Write-Verbose -Message "Setting 'Paging File Size' for drive '$DriveLetter' to '$ManagementMsg' ..."

                $DriveLetter = $DriveLetter.Replace('\', '')

                $PagingFileProperties = @{
                    ClassName = 'Win32_PageFileSetting'
                    Filter    = "Name like '$DriveLetter%'"
                }
                $PagingFileSetting = Get-CimInstance @PagingFileProperties -Verbose:$false

                if ($Management -eq 'NoPagingFile')
                {
                    if ($PagingFileSetting)
                    {
                        Remove-CimInstance -InputObject $PagingFileSetting -Verbose:$false
                    }
                }
                else
                {
                    if (-not $PagingFileSetting)
                    {
                        $NewPagingFileProperties = @{
                            ClassName = 'Win32_PageFileSetting'
                            Property  = @{ Name = "$DriveLetter\pagefile.sys" }
                        }
                        $PagingFileSetting = New-CimInstance @NewPagingFileProperties -Verbose:$false
                    }

                    if ($Management -eq 'SystemManaged')
                    {
                        $InitialSizeMB = $MaximumSizeMB = 0
                    }

                    $PagingFileSetting.InitialSize = $InitialSizeMB
                    $PagingFileSetting.MaximumSize = $MaximumSizeMB
                    Set-CimInstance -InputObject $PagingFileSetting -Verbose:$false
                }
            }
        }
    }
}
