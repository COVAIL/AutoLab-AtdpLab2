<# Notes:

Authors: Jason Helmick and Melissa (Missy) Januszko

The bulk of this DC, DHCP, ADCS config is authored by Melissa (Missy) Januszko and Jason Helmick.
Currently on her public DSC hub located here: https://github.com/majst32/DSC_public.git

Additional contributors of note: Jeff Hicks

Disclaimer
This example code is provided without copyright and AS IS.  It is free for you to use and modify.
#>

@{
    AllNodes    = @(
        @{
            NodeName                    = '*'

            # Lab Password - assigned to Administrator and Users
            LabPassword                 = 'P@ssw0rd'

            # Common networking
            InterfaceAlias              = 'Ethernet'
            DefaultGateway              = '192.168.3.1'
            SubnetMask                  = 24
            AddressFamily               = 'IPv4'
            IPNetwork                   = '192.168.3.0/24'
            IPNatName                   = 'LabNat'
            DnsServerAddress            = '192.168.3.10'

            # Firewall settings to enable
            FirewallRuleNames           = @(
                'FPS-ICMP4-ERQ-In';
                'FPS-ICMP6-ERQ-In';
                'FPS-SMB-In-TCP'
            )

            # Domain and Domain Controller information
            DomainName                  = "AtdpLab2.Pri"
            DomainDN                    = "DC=AtdpLab2,DC=Pri"
            DCDatabasePath              = "C:\NTDS"
            DCLogPath                   = "C:\NTDS"
            SysvolPath                  = "C:\Sysvol"
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser        = $true

            # DHCP Server Data
            DHCPName                    = 'LabNet2'
            DHCPIPStartRange            = '192.168.3.200'
            DHCPIPEndRange              = '192.168.3.250'
            DHCPSubnetMask              = '255.255.255.0'
            DHCPState                   = 'Active'
            DHCPAddressFamily           = 'IPv4'
            DHCPLeaseDuration           = '00:08:00'
            DHCPScopeID                 = '192.168.3.0'
            DHCPDnsServerIPAddress      = '192.168.3.10'
            DHCPRouter                  = '192.168.3.1'

            # ADCS Certificate Services information
            CACN                        = 'AtdpLab2.Pri'
            CADNSuffix                  = "C=US,L=Columbus,S=Ohio,O=AtdpLab2"
            CADatabasePath              = "C:\windows\system32\CertLog"
            CALogPath                   = "C:\CA_Logs"
            ADCSCAType                  = 'StandaloneRootCA'
            ADCSCryptoProviderName      = 'RSA#Microsoft Software Key Storage Provider'
            ADCSHashAlgorithmName       = 'SHA256'
            ADCSKeyLength               = 2048
            ADCSValidityPeriod          = 'Years'
            ADCSValidityPeriodUnits     = 2

            # Lability default node settings
            Lability_SwitchName         = 'SeverNet2'
            Lability_ProcessorCount     = 1
            Lability_MinimumMemory      = 2GB
            SecureBoot                  = $false
            Lability_Media              = '2019_x64_Standard_EN_Eval'
        }

        <#    Available Roles for computers
        DC = Domain Controller
        DHCP = Dynamic Host Configuration Protocol
        ADCS = Active Directory Certificate SErvices - plus autoenrollment GPO's and DSC and web server certs
        Web = Basic web server
        RSAT = Remote Server Administration Tools for the client
        RDP = enables RDP and opens up required firewall rules
        DomainJoin = joions a computer to the domain
#>
        @{
            NodeName                = 'DC1'
            IPAddress               = '192.168.3.10'
            Role                    = @('DC', 'DHCP', 'RDP')
            Lability_BootOrder      = 10
            Lability_BootDelay      = 60 # Number of seconds to delay before others
            Lability_timeZone       = 'US Eastern Standard Time' #[System.TimeZoneInfo]::GetSystemTimeZones()
            Lability_Media          = '2019_x64_Standard_EN_Eval'
            Lability_StartupMemory  = 4096MB
            Lability_ProcessorCount = 2
            CustomBootStrap         = @'
                    # This must be set to handle larger .mof files
                    Set-Item -path wsman:\localhost\maxenvelopesize -value 1000
'@
        }

        @{
            NodeName                = 'DC2'
            IPAddress               = '192.168.3.11'
            Role                    = @('DomainJoin', 'RDP')
            Lability_BootOrder      = 11
            Lability_BootDelay      = 60 # Number of seconds to delay before others
            Lability_timeZone       = 'US Eastern Standard Time' #[System.TimeZoneInfo]::GetSystemTimeZones()
            Lability_Media          = '2019_x64_Standard_EN_Eval'
            Lability_StartupMemory  = 4096MB
            Lability_ProcessorCount = 2
            CustomBootStrap         = @'
                    # This must be set to handle larger .mof files
                    Set-Item -path wsman:\localhost\maxenvelopesize -value 1000
'@
        }

        @{
            NodeName           = 'Server1'
            IPAddress          = '192.168.3.50'
            #Role = 'DomainJoin' # example of multiple roles @('DomainJoin', 'Web')
            Role               = @('DomainJoin', 'RDP')
            Lability_BootOrder = 20
            Lability_BootDelay = 60 # Number of seconds to delay before others
            Lability_timeZone  = 'US Eastern Standard Time' #[System.TimeZoneInfo]::GetSystemTimeZones()
            Lability_Media          = '2019_x64_Standard_EN_Eval'
        }

        @{
            NodeName           = 'Collector1'
            IPAddress          = '192.168.3.20'
            #Role = 'DomainJoin' # example of multiple roles @('DomainJoin', 'Web')
            Role               = @('DomainJoin', 'RDP')
            Lability_BootOrder = 20
            Lability_BootDelay = 60 # Number of seconds to delay before others
            Lability_timeZone  = 'US Eastern Standard Time' #[System.TimeZoneInfo]::GetSystemTimeZones()
            Lability_Media          = '2019_x64_Standard_EN_Eval'
        }

        @{
            NodeName           = 'Grandpa1'
            IPAddress          = '192.168.3.55'
            Role               = @('DomainJoin', 'RDP')
            Lability_BootOrder = 20
            Lability_timeZone  = 'US Eastern Standard Time' #[System.TimeZoneInfo]::GetSystemTimeZones()
            Lability_Media          = '2012R2_x64_Standard_EN_Eval'
        }

        
        @{
            NodeName                = 'Client1'
            IPAddress               = '192.168.4.100'
            DefaultGateway          = '192.168.4.1'
            Role                    = @('DomainJoin', 'RSAT', 'RDP')
            Lability_ProcessorCount = 2
            Lability_Media          = 'WIN10_x64_Enterprise_EN_Eval'
            Lability_BootOrder      = 20
            Lability_timeZone       = 'US Eastern Standard Time' #[System.TimeZoneInfo]::GetSystemTimeZones()
            Lability_SwitchName     = @('ClientNet2')
            Lability_Resource       = @()
            CustomBootStrap         = @'
                    # To enable PSRemoting on the client
                    Enable-PSRemoting -SkipNetworkProfileCheck -Force;
'@
        }

        @{
            NodeName = 'Firewall'
            Lability_SwitchName = @('External', 'SeverNet2', 'ClientNet2')
            Lability_BootOrder      = 1
            Lability_Media = 'PFSENSE_2_4_5'
        }
    
    )

    NonNodeData = @{
        Lability = @{

            # You can uncomment this line to add a prefix to the virtual machine name.
            # It will not change the guest computername
            # See https://github.com/pluralsight/PS-AutoLab-Env/blob/master/Detailed-Setup-Instructions.md
            # for more information.

            EnvironmentPrefix = 'AtdpLab2-'
            Media       = (
                @{
                    <#
                    ## This media is a replica of the default '2016_x64_Standard_Nano_EN_Eval' media
                    ## with the additional 'Microsoft-NanoServer-DSC-Package' package added.
                    Id              = '2016_x64_Standard_Nano_DSC_EN_Eval'
                    Filename        = '2016_x64_EN_Eval.iso'
                    Description     = 'Windows Server 2016 Standard Nano 64bit English Evaluation'
                    Architecture    = 'x64'
                    ImageName       = 'Windows Server 2016 SERVERSTANDARDNANO'
                    MediaType       = 'ISO'
                    OperatingSystem = 'Windows'
                    Uri             = 'http://download.microsoft.com/download/1/6/F/16FA20E6-4662-482A-920B-1A45CF5AAE3C/14393.0.160715-1616.RS1_RELEASE_SERVER_EVAL_X64FRE_EN-US.ISO'
                    Checksum        = '18A4F00A675B0338F3C7C93C4F131BEB'
                    CustomData      = @{
                        SetupComplete = 'CoreCLR'
                        PackagePath   = '\NanoServer\Packages'
                        PackageLocale = 'en-US'
                        WimPath       = '\NanoServer\NanoServer.wim'
                        Package       = @(
                            'Microsoft-NanoServer-Guest-Package',
                            'Microsoft-NanoServer-DSC-Package'
                            )
                        }
                        #>
                }
            ) # Custom media additions that are different than the supplied defaults (media.json)
            Network     = @( # Virtual switch in Hyper-V
                @{ Name = 'SeverNet2'; Type = 'Internal'; NetAdapterName = 'Ethernet'; AllowManagementOS = $true }
                @{ Name = 'ClientNet2'; Type = 'Internal'; NetAdapterName = 'Ethernet'; AllowManagementOS = $true }
                @{ Name = 'External'; Type = 'External'; NetAdapterName = 'Ethernet'; AllowManagementOS = $true }
            )
            DSCResource = @(
                ## Download published version from the PowerShell Gallery or Github
                @{ Name = 'xActiveDirectory'; RequiredVersion = '3.0.0.0'; Provider = 'PSGallery' },
                @{ Name = 'xComputerManagement'; RequiredVersion = '4.1.0.0'; Provider = 'PSGallery' },
                @{ Name = 'xNetworking'; RequiredVersion = '5.7.0.0'; Provider = 'PSGallery' },
                @{ Name = 'xDhcpServer'; RequiredVersion = '2.0.0.0'; Provider = 'PSGallery' },
                @{ Name = 'xWindowsUpdate' ; RequiredVersion = '2.8.0.0'; Provider = 'PSGallery' },
                @{ Name = 'xPSDesiredStateConfiguration'; RequiredVersion = '9.1.0' }
                @{ Name = 'xADCSDeployment'; RequiredVersion = '1.4.0.0' }

            )
            Resource    = @(
                @{
                    Id       = 'Win10RSAT'
                    Filename = 'WindowsTH-RSAT_WS2016-x64.msu'
                    Uri      = 'https://download.microsoft.com/download/1/D/8/1D8B5022-5477-4B9A-8104-6A71FF9D98AB/WindowsTH-RSAT_WS2016-x64.msu'
                    Expand   = $false
                    #DestinationPath = '\software' # Default is resources folder
                }
            )
        }
    }
}
