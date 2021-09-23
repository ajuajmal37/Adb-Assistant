import sys
import socket
import nmap


ipv4_addrs =[]

nmScan = nmap.PortScanner()

nmScan.scan('192.168.2.13/24', '22-150','-O -Pn  -A')
for host in nmScan.all_hosts():
     for proto in nmScan[host].all_protocols():
        lport = nmScan[host][proto].keys()
        # print(lport)
        # lport.sort()
        for port in lport:
            if nmScan[host][proto][port]['state'] == 'open':
                dict ={
					"vendor": nmScan[host]['osmatch'][0]['osclass'][0]['vendor'],
					'osfamily' :nmScan[host]['osmatch'][0]['osclass'][0]['osfamily'],
					"ipv4" : nmScan[host]['addresses']['ipv4']
				}
                ipv4_addrs.append(dict)



print(ipv4_addrs)