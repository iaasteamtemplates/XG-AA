Param
(
  [Parameter (Mandatory= $true)]
  [String] $password,
  [Parameter (Mandatory= $true)]
  [String] $portagw,
  [Parameter (Mandatory= $true)]
  [String] $portbgw,
  [Parameter (Mandatory= $true)]
  [String] $hostname,
  [Parameter (Mandatory= $true)]
  [String] $sshport
)
$secpassword = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ("admin", $secpassword)
$session = New-SSHSession -ComputerName $hostname -Credential $creds -AcceptKey -Port $sshport
$SSHStream = New-SSHShellStream -SessionId $session.SessionId
If ($session.Connected) {
    Start-Sleep -s 10
	$SSHStream.WriteLine("a")
    Start-Sleep -s 5
	$SSHStream.WriteLine(" ")
	$SSHStream.WriteLine(" ")
	Start-Sleep -s 5
	$SSHStream.WriteLine("5")
    Start-Sleep -s 5
    $SSHStream.WriteLine("3")
    Start-Sleep -s 5
    $SSHStream.WriteLine("touch /tmp/zebraman.conf")
    Start-Sleep -s 5
    $SSHStream.WriteLine("cat >/tmp/zebraman.conf <<EOL")
    $SSHStream.WriteLine("!")
    $SSHStream.WriteLine("! ZEBRA configuration file")
    $SSHStream.WriteLine("!")
    $SSHStream.WriteLine("hostname router")
    $SSHStream.WriteLine("log stdout")
    $SSHStream.WriteLine("line vty")
    $SSHStream.WriteLine("no login")
    $SSHStream.WriteLine("ip route 168.63.129.16/32 $portagw PortA")
    $SSHStream.WriteLine("ip route 168.63.129.16/32 $portbgw PortB")
    $SSHStream.WriteLine("!")
    $SSHStream.WriteLine("EOL")
    Start-Sleep -s 5
    $SSHStream.WriteLine("killall zebra")
    Start-Sleep -s 10
    $SSHStream.WriteLine("zebra -f /tmp/zebraman.conf > /dev/null &")
    Start-Sleep -s 10
    $SSHStream.WriteLine("reboot")
    Start-Sleep -s 2
    $SSHStream.Read()  
    Remove-SSHSession -SessionId $session.SessionId > $null
}
Else {
    "Could not connect to XG"
    Get-SSHSession | Remove-SSHSession > $null
}