#Set variables
$RemoteZabbixPath = '\\net_share\'
$LocalZabbixPath = 'C:\Zabbix\'
$LocalZabbixConf = 'C:\Zabbix\zabbix_agentd.conf'
$Zabbix = 'Zabbix Agent'

#Function install zabbix like service
function Install_zabbix {
& C:\Zabbix\zabbix_agentd.exe -i -c $LocalZabbixConf
}

#Function start Zabbix Service
function Run_Zabbix {
Start-Service $Zabbix
}

#Function stop Zabbix Service
function Stop_Zabbix {
    Stop-Service $Zabbix
    }


#Check path exist and changes in .conf, if conf file changed zabbix reconfigured when server restart.
If (!(Test-Path -Path $LocalZabbixPath)) {
    Copy-Item $RemoteZabbixPath $LocalZabbixPath -Recurse -Force
    Install_zabbix
    Run_Zabbix
    Exit
    }
else {
    $Rem = Get-FileHash '\\net_share\zabbix_agentd.conf' -Algorithm SHA256 
    $loc = Get-FileHash 'C:\Zabbix\zabbix_agentd.conf' -Algorithm SHA256
    If ($Rem.Hash -ne $loc.Hash) {
        Stop_Zabbix
        Remove-Item -Path $LocalZabbixPath -Force -Recurse
        Copy-Item $RemoteZabbixPath $LocalZabbixPath -Recurse -Force
        Run_Zabbix
        Exit
        }
    Else {Exit}
}

Exit
