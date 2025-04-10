#=================================================================================================================
#                                               Windows Answer File
#=================================================================================================================

<#
  Create a local account and disable Bitlocker auto device encryption.
  Disable password expiration as well (a force password reset is not recommended).

  See the below minimal autounattend.xml file.
  More customization can be done, see Microsoft documentation and/or the online generator.
  https://schneegans.de/windows/unattend-generator/
#>

<#
.SYNTAX
    New-WindowsAnswerFile
        [[-Path] <string>]
        [[-UserName] <string>]
        [[-Edition] {Home | Pro | Enterprise}]
        [<CommonParameters>]
#>

<#
.DESCRIPTION
    UserName will be trimed (i.e. Space characters will be removed from the start and end).

    Copy the "autounattend.xml" file to the USB drive root folder.
    It can be the "Windows installation" USB or another USB drive.

.EXAMPLE
    PS> New-WindowsAnswerFile.ps1
    Enter password (empty allowed): MyPassword
    PS> Get-ChildItem -Name
    autounattend.xml

.EXAMPLE
    PS> New-WindowsAnswerFile.ps1 -Path 'X:\Documents' -UserName 'MyUserName' -Edition 'Home'
    Enter password (empty allowed): MyPassword
    PS> Get-ChildItem -Path 'X:\Documents' -Name
    autounattend.xml
#>

[CmdletBinding()]
param
(
    [string] $Path = $PSScriptRoot,

    [ValidateScript(
        {
            $_.Trim() -and -not $_.Trim().EndsWith('.')
        },
        ErrorMessage = 'User name can''t end with a dot or contain only space and/or dot.')]
    [ValidateScript(
        {
            $UnAllowedChars = '/\\\[\]:\|<>\+=;,\?\*%"@'
            $_ -notmatch "[$UnAllowedChars]"
        },
        ErrorMessage = 'User name can''t contain these characters: / \ [ ] : | < > + = ; , ? * % " @')]
    [ValidateScript(
        {
            $UnAllowedNames = @(
                'Administrator'
                'DefaultAccount'
                'Guest'
                'Local Service'
                'Network Service'
                'None'
                'System'
                'WDAGUtilityAccount'
            )
            $UnAllowedNames -notcontains $_.Trim()
        },
        ErrorMessage = 'Invalid User name. User name can''t use reserved names.')]
    [ValidateLength(1, 20)]
    [string] $UserName = 'User',

    [ValidateSet('Home', 'Pro', 'Enterprise')]
    [string] $Edition = ''
)

process
{
    # Prompt the Password to prevents command-line history exposure.
    $Password = Read-Host -Prompt "Enter password (empty allowed)"

    $UserName = $UserName.Trim()
    $WindowsEdition = switch ($Edition)
    {
        'Home'       { 'YTMG3-N6DKC-DKB77-7M9GH-8HVX7' }
        'Pro'        { 'VK7JG-NPHTM-C97JM-9MPGT-3V66T' }
        'Enterprise' { 'XGVPP-NMH47-7TTHJ-W3FW7-8HV2C' }
        Default      { '00000-00000-00000-00000-00000' }
    }

    $AnswerFile = @"
        <?xml version="1.0" encoding="utf-8"?>
        <unattend xmlns="urn:schemas-microsoft-com:unattend" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
            <settings pass="offlineServicing"></settings>
            <settings pass="windowsPE">
                <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
                    <UserData>
                        <ProductKey>
                            <!-- Win11 generic product key: -->
                                <!-- Home: YTMG3-N6DKC-DKB77-7M9GH-8HVX7 -->
                                <!-- Pro: VK7JG-NPHTM-C97JM-9MPGT-3V66T -->
                                <!-- Enterprise: XGVPP-NMH47-7TTHJ-W3FW7-8HV2C -->
                            <!-- choose a generic key to install a specific version and skip the Windows Key screen -->
                            <Key>$WindowsEdition</Key>
                        </ProductKey>
                        <AcceptEula>true</AcceptEula>
                    </UserData>
                </component>
            </settings>
            <settings pass="generalize"></settings>
            <settings pass="specialize">
                <component name="Microsoft-Windows-Deployment" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
                    <RunSynchronous>
                        <RunSynchronousCommand wcm:action="add">
                            <!-- disable password expiration -->
                            <Order>1</Order>
                            <Path>net.exe accounts /maxpwage:UNLIMITED</Path>
                        </RunSynchronousCommand>
                        <RunSynchronousCommand wcm:action="add">
                            <!-- disable Bitlocker auto device encryption -->
                            <Order>2</Order>
                            <Path>reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\BitLocker" /v "PreventDeviceEncryption" /t REG_DWORD /d 1 /f</Path>
                        </RunSynchronousCommand>
                    </RunSynchronous>
                </component>
            </settings>
            <settings pass="auditSystem"></settings>
            <settings pass="auditUser"></settings>
            <settings pass="oobeSystem">
                <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
                    <UserAccounts>
                        <!-- create a local account (modify the username (20 chars max) and password) -->
                        <LocalAccounts>
                            <LocalAccount wcm:action="add">
                                <Name>$UserName</Name>
                                <Group>Administrators</Group>
                                <Password>
                                    <Value>$Password</Value>
                                    <PlainText>true</PlainText>
                                </Password>
                            </LocalAccount>
                        </LocalAccounts>
                    </UserAccounts>
                    <AutoLogon>
                        <!-- auto logon once (modify the username and password with the above LocalAccount values) -->
                        <Username>$UserName</Username>
                        <Enabled>true</Enabled>
                        <LogonCount>1</LogonCount>
                        <Password>
                            <Value>$Password</Value>
                            <PlainText>true</PlainText>
                        </Password>
                    </AutoLogon>
                    <OOBE>
                        <!-- deny privacy settings (do not send diagnostics data, ... etc) -->
                        <ProtectYourPC>3</ProtectYourPC>
                        <HideEULAPage>true</HideEULAPage>
                        <HideWirelessSetupInOOBE>false</HideWirelessSetupInOOBE>
                    </OOBE>
                    <FirstLogonCommands>
                        <SynchronousCommand wcm:action="add">
                            <!-- disable auto logon after the first logon -->
                            <Order>1</Order>
                            <CommandLine>reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonCount /t REG_DWORD /d 0 /f</CommandLine>
                        </SynchronousCommand>
                    </FirstLogonCommands>
                </component>
            </settings>
        </unattend>
"@

        $AnswerFile = $AnswerFile -replace '(?m)^ {8}'
        Out-File -InputObject $AnswerFile -Path "$Path\autounattend.xml"
}
