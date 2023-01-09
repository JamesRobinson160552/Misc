#File: ping_test.ps1
#Author: James Robinson 100160552
#Purpose: 
#   tests internet connection by pinging google.com and saves the results in a text file and csv
#   samples once every $wait_time seconds a total of $count times     

$myPC = $env:COMPUTERNAME
$target = "www.google.com"
$packet_size = 1024
$count = 60
$wait_time = 30 #seconds
$date = Get-Date -Format "MM-dd-yyy"
$out_file = "C:\Users\james\Downloads\Current School\3343_DataComm\Final\" + "MaxSecure" + ".txt" #file name will be date of test
$csv_out_file = "C:\Users\james\Downloads\Current School\3343_DataComm\Final\" + "MaxSecure" + ".csv"

#Write-Host $date
#Write-Host $out_file

#Create new output file if one does not already exist for the day
if (-Not(Test-Path $out_file)) {
    New-Item -Path $out_file
}

if (-Not(Test-Path $csv_out_file)) {
    New-Item -Path $csv_out_file
}

$output = "VPN ping test - " + $date + "`n`n"
$csv_output = "Response Times(ms)`n"

#pings $target $count times with $wait_time between each ping
#records the results in $out_file
for ($i=1; $i -lt $count+1; $i++) {
    Write-Host "test: " $i
    $output += "Time: "
    $output += Get-Date -Format "HH:mm" #preceeds ping result with time of test
    $output += " Result(ms): "
    $nthTrial = Test-Connection -Source $myPC -Destination $target -Count 1 -BufferSize $packet_size | Select-Object ResponseTime | ForEach-Object {$_.ResponseTime}
    $output += $nthTrial
    $output += "`n"
    $csv_output += $nthTrial
    $csv_output += "`n"
    Start-Sleep -Seconds $wait_time
}

$output | Out-File -FilePath $out_file -Append
$csv_output | Out-File $csv_out_file
