# PowerShell script to establish SSH tunnel for Mozartv3
$remoteHost = "148.135.185.20"
$remotePort = 15407
$localPort = 8080
$sshUser = "root"

Write-Output "Establishing SSH tunnel: localhost:$localPort -> $remoteHost:$localPort"
Start-Process -NoNewWindow -FilePath "ssh" -ArgumentList "-p $remotePort $sshUser@$remoteHost -L $localPort:localhost:$localPort"