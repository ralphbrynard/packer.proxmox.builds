<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="windowsPE">
        <component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <SetupUILanguage>
                <UILanguage>${vm_inst_os_language}</UILanguage>
            </SetupUILanguage>
            <InputLocale>${vm_inst_os_keyboard}</InputLocale>
            <SystemLocale>${vm_inst_os_language}</SystemLocale>
            <UILanguage>${vm_inst_os_language}</UILanguage>
            <UILanguageFallback>${vm_inst_os_language}</UILanguageFallback>
            <UserLocale>${vm_inst_os_language}</UserLocale>
        </component>
        <component name="Microsoft-Windows-PnpCustomizationsWinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <DriverPaths>
                <PathAndCredentials wcm:action="add" wcm:keyValue="1">
                    <Path>E:\drivers</Path>
                </PathAndCredentials>
            </DriverPaths>
        </component>
        <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
%{ if is_efi == true ~}
         <DiskConfiguration>
            <Disk wcm:action="add">
               <DiskID>0</DiskID>
               <WillWipeDisk>true</WillWipeDisk>
               <CreatePartitions>
                  <!-- Windows RE Tools partition -->
                  <CreatePartition wcm:action="add">
                     <Order>1</Order>
                     <Type>Primary</Type>
                     <Size>300</Size>
                  </CreatePartition>
                  <!-- System partition (ESP) -->
                  <CreatePartition wcm:action="add">
                     <Order>2</Order>
                     <Type>EFI</Type>
                     <Size>100</Size>
                  </CreatePartition>
                  <!-- Microsoft reserved partition (MSR) -->
                  <CreatePartition wcm:action="add">
                     <Order>3</Order>
                     <Type>MSR</Type>
                     <Size>128</Size>
                  </CreatePartition>
                  <!-- Windows partition -->
                  <CreatePartition wcm:action="add">
                     <Order>4</Order>
                     <Type>Primary</Type>
                     <Extend>true</Extend>
                  </CreatePartition>
               </CreatePartitions>
               <ModifyPartitions>
                  <!-- Windows RE Tools partition -->
                  <ModifyPartition wcm:action="add">
                     <Order>1</Order>
                     <PartitionID>1</PartitionID>
                     <Label>WINRE</Label>
                     <Format>NTFS</Format>
                     <TypeID>DE94BBA4-06D1-4D40-A16A-BFD50179D6AC</TypeID>
                  </ModifyPartition>
                  <!-- System partition (ESP) -->
                  <ModifyPartition wcm:action="add">
                     <Order>2</Order>
                     <PartitionID>2</PartitionID>
                     <Label>System</Label>
                     <Format>FAT32</Format>
                  </ModifyPartition>
                  <!-- MSR partition does not need to be modified -->
                  <ModifyPartition wcm:action="add">
                     <Order>3</Order>
                     <PartitionID>3</PartitionID>
                  </ModifyPartition>
                  <!-- Windows partition -->
                  <ModifyPartition wcm:action="add">
                     <Order>4</Order>
                     <PartitionID>4</PartitionID>
                     <Label>OS</Label>
                     <Letter>C</Letter>
                     <Format>NTFS</Format>
                  </ModifyPartition>
               </ModifyPartitions>
            </Disk>
         </DiskConfiguration>
%{ else ~}        
            <DiskConfiguration>
                <Disk wcm:action="add">
                    <DiskID>0</DiskID>
                    <WillWipeDisk>true</WillWipeDisk>
                    <CreatePartitions>
                        <CreatePartition wcm:action="add">
                            <Order>1</Order>
                            <Size>500</Size>
                            <Type>Primary</Type>
                        </CreatePartition>
                        <CreatePartition wcm:action="add">
                            <Extend>true</Extend>
                            <Order>2</Order>
                            <Type>Primary</Type>
                        </CreatePartition>
                    </CreatePartitions>
                    <ModifyPartitions>
                        <ModifyPartition wcm:action="add">
                            <Format>NTFS</Format>
                            <Label>Windows</Label>
                            <Letter>C</Letter>
                            <Order>2</Order>
                            <PartitionID>2</PartitionID>
                        </ModifyPartition>
                        <ModifyPartition wcm:action="add">
                            <Active>true</Active>
                            <Format>NTFS</Format>
                            <Label>System</Label>
                            <Order>1</Order>
                            <PartitionID>1</PartitionID>
                        </ModifyPartition>
                    </ModifyPartitions>
                </Disk>
                <WillShowUI>OnError</WillShowUI>
            </DiskConfiguration>
%{ endif ~}            
            <ImageInstall>
                <OSImage>
                    <InstallTo>
                        <DiskID>0</DiskID>
                        <PartitionID>2</PartitionID>
                    </InstallTo>
                    <InstallFrom>
                        <MetaData wcm:action="add">
                            <Key>/IMAGE/NAME</Key>
                            <Value>${vm_inst_os_image}</Value>
                        </MetaData>
                    </InstallFrom>
                </OSImage>
            </ImageInstall>
            <RunSynchronous>
                <RunSynchronousCommand wcm:action="add">
                    <Description>Add BypassTPMCheck key</Description>
                    <Order>1</Order>
                    <Path>reg add HKLM\SYSTEM\Setup\LabConfig /v ByPassTPMCheck /t REG_DWORD /d 0x00000001</Path>
                </RunSynchronousCommand>
                <RunSynchronousCommand wcm:action="add">
                    <Description>Add BypassRAMCheck key</Description>
                    <Order>2</Order>
                    <Path>reg add HKLM\SYSTEM\Setup\LabConfig /v BypassRAMCheck /t REG_DWORD /d 0x00000001</Path>
                </RunSynchronousCommand>
                <RunSynchronousCommand wcm:action="add">
                    <Description>Add Bypass Secure Boot Check</Description>
                    <Order>3</Order>
                    <Path>reg add HKLM\SYSTEM\Setup\LabConfig /v BypassSecureBootCheck /t REG_DWORD /d 0x00000001</Path>
                </RunSynchronousCommand>
                <RunSynchronousCommand wcm:action="add">
                    <Description>Set power scheme to high performance in WinPE for faster imaging.</Description>
                    <Order>4</Order>
                    <Path>cmd /c powercfg.exe /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c</Path>
                </RunSynchronousCommand>
            </RunSynchronous>
            <UserData>
                <ProductKey>
                    <Key>${vm_inst_os_kms_key}</Key>
                    <WillShowUI>OnError</WillShowUI>
                </ProductKey>
                <AcceptEula>true</AcceptEula>
                <FullName>${build_username}</FullName>
                <Organization>${build_username}</Organization>
            </UserData>
            <RunAsynchronous>
                <RunAsynchronousCommand wcm:action="add">
                    <Description>Disable First Logon Animation</Description>
                    <Order>1</Order>
                    <Path>reg add &quot;HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon&quot; /v EnableFirstLogonAnimation /t REG_DWORD /d 0 /f</Path>
                </RunAsynchronousCommand>
            </RunAsynchronous>            
        </component>
    </settings>
    <settings pass="offlineServicing">
        <component name="Microsoft-Windows-LUA-Settings" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <EnableLUA>false</EnableLUA>
        </component>
    </settings>
    <settings pass="generalize">
        <component name="Microsoft-Windows-Security-SPP" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <SkipRearm>1</SkipRearm>
        </component>
    </settings>
    <settings pass="specialize">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <OEMInformation>
                <HelpCustomized>false</HelpCustomized>
            </OEMInformation>
            <TimeZone>${vm_guest_os_timezone}</TimeZone>
        </component>
        <component name="Microsoft-Windows-OutOfBoxExperience" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <DoNotOpenInitialConfigurationTasksAtLogon>true</DoNotOpenInitialConfigurationTasksAtLogon>
        </component>        
        <component name="Microsoft-Windows-Security-SPP-UX" processorArchitecture="wow64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <SkipAutoActivation>true</SkipAutoActivation>
        </component>
    </settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <InputLocale>${vm_guest_os_keyboard}</InputLocale>
            <SystemLocale>${vm_guest_os_language}</SystemLocale>
            <UILanguage>${vm_guest_os_language}</UILanguage>
            <UILanguageFallback>${vm_guest_os_language}</UILanguageFallback>
            <UserLocale>${vm_guest_os_language}</UserLocale>
        </component>
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <AutoLogon>
                <Password>
                    <Value>${build_password}</Value>
                    <PlainText>true</PlainText>
                </Password>
                <Enabled>true</Enabled>
                <Username>${build_username}</Username>
            </AutoLogon>
            <FirstLogonCommands>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command &quot;Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force&quot;</CommandLine>
                    <Description>Set Execution Policy 64-Bit</Description>
                    <Order>1</Order>
                    <RequiresUserInput>true</RequiresUserInput>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -Command &quot;Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force&quot;</CommandLine>
                    <Description>Set Execution Policy 32-Bit</Description>
                    <Order>2</Order>
                    <RequiresUserInput>true</RequiresUserInput>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Description>Initial Configuration</Description>
                    <CommandLine>%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -File E:\windows\windows-init.ps1</CommandLine>
                    <Order>3</Order>
                </SynchronousCommand>                              
            </FirstLogonCommands>
            <UserAccounts>
                <AdministratorPassword>
                    <Value>${build_password}</Value>
                    <PlainText>true</PlainText>
                </AdministratorPassword>
                <LocalAccounts>
                    <LocalAccount wcm:action="add">
                        <Password>
                            <Value>${build_password}</Value>
                            <PlainText>true</PlainText>
                        </Password>
                        <Description>Build Account</Description>
                        <DisplayName>${build_username}</DisplayName>
                        <Group>administrators</Group>
                        <Name>${build_username}</Name>
                    </LocalAccount>                   
                </LocalAccounts>              
            </UserAccounts>
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                <HideLocalAccountScreen>true</HideLocalAccountScreen>
                <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
                <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
                <ProtectYourPC>2</ProtectYourPC>
            </OOBE>
        </component>
    </settings>
</unattend>
