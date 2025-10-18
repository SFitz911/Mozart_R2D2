# Start DeepSeek: creates an SSH tunnel and ensures remote demo is running
param(
    [string]$KeyPath = "$env:USERPROFILE\\.ssh\\id_ed25519",
    [string]$RemoteUser = "root",
    [string]$RemoteHost = "148.135.185.20",
    [int]$RemotePort = 15407,
    [int]$LocalPort = 7860,
    [int]$RemoteServicePort = 7860
)

# Ensure key exists
if (-not (Test-Path $KeyPath)) {
    Write-Error "SSH key not found: $KeyPath"
    exit 1
}

# Start remote service (runs remote helper script which starts tmux/session)
Write-Output "Starting remote DeepSeek service..."
# Upload persistent helper into the repo and run it. This ensures the helper persists across reboots.
scp -P $RemotePort -i "$KeyPath" "$PSScriptRoot\\remote_start.sh" $RemoteUser@$RemoteHost:/root/Mozart_R2D2/deploy/deepseek_source/start_deepseek_remote.sh
ssh -o StrictHostKeyChecking=no -i "$KeyPath" -p $RemotePort $RemoteUser@$RemoteHost "chmod +x /root/Mozart_R2D2/deploy/deepseek_source/start_deepseek_remote.sh && bash /root/Mozart_R2D2/deploy/deepseek_source/start_deepseek_remote.sh" | Write-Output

Start-Sleep -Seconds 1

# Create SSH tunnel in a new background process
$sshArgs = "-o StrictHostKeyChecking=no -i `"$KeyPath`" -p $RemotePort -L $LocalPort:localhost:$RemoteServicePort $RemoteUser@$RemoteHost -N"
Write-Output "Creating SSH tunnel: localhost:$LocalPort -> $RemoteHost:$RemoteServicePort"
Start-Process -WindowStyle Minimized -FilePath ssh -ArgumentList $sshArgs
Write-Output "Tunnel started (check Task Manager for ssh process). Open http://localhost:$LocalPort in your browser."