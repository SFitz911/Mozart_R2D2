param(
    [string]$KeyPath = "$env:USERPROFILE\\.ssh\\id_ed25519",
    [string]$RemoteUser = "root",
    [string]$RemoteHost = "148.135.185.20",
    [int]$RemotePort = 15407
)

# Kill ssh tunnel processes that match the remote host
Write-Output "Stopping local ssh tunnel(s) to $RemoteHost..."
Get-Process -Name ssh -ErrorAction SilentlyContinue | Where-Object {
    $_.Path -ne $null -and $_.StartInfo.Arguments -match $RemoteHost
} | ForEach-Object { Stop-Process -Id $_.Id }

# Stop remote tmux session
Write-Output "Stopping remote DeepSeek tmux session..."
ssh -o StrictHostKeyChecking=no -i "$KeyPath" -p $RemotePort $RemoteUser@$RemoteHost "tmux kill-session -t deepseek || true; rm -f /tmp/start_deepseek_remote.sh || true" | Write-Output
Write-Output "Stopped."