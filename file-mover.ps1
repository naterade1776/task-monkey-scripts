#Requires -RunAsAdministrator
read-host "This script will bundle a user's information from an old device and move it to a new device. Press ENTER to continue."
$sdevice = read-host "Source Device"
$user = read-host "Username"
$ddevice = read-host "Destination Device"
Get-WmiObject -Class Win32_LogicalDisk -computername $ddevice |
Select-Object -Property DeviceID, VolumeName, @{Label='FreeSpace (Gb)'; expression={($_.FreeSpace/1GB).ToString('F2')}},
@{Label='Total (Gb)'; expression={($_.Size/1GB).ToString('F2')}},
@{label='FreePercent'; expression={[Math]::Round(($_.freespace / $_.size) * 100, 2)}}|ft
$yon = read-host "Verify the destination has sufficient space. Continue? (Y/N)"
if ( $yon -eq 'n' ) {
    write-host "Exiting..."
    exit
    } else {
    write-host "Continuing..."
    }
$target = read-host "Move all user files? (A), or Specify a folder (S) "
if ( $target -eq 'a') {
    mkdir \\$ddevice\c$\$user-migrated
    write-host "Moving Desktop..." -ForegroundColor Yellow
    copy-item -Path \\$sdevice\C$\Users\$user\Desktop -Destination \\$ddevice\c$\$user-migrated -Recurse
        write-host "Moving Downloads..." -ForegroundColor Yellow
    copy-item -Path \\$sdevice\C$\Users\$user\Downloads -Destination \\$ddevice\c$\$user-migrated -Recurse
        write-host "Moving Documents..." -ForegroundColor Yellow
    copy-item -Path \\$sdevice\C$\Users\$user\Documents -Destination \\$ddevice\c$\$user-migrated -Recurse
        write-host "Moving Pictures..." -ForegroundColor Yellow
    copy-item -Path \\$sdevice\C$\Users\$user\Pictures -Destination \\$ddevice\c$\$user-migrated -Recurse
        write-host "Moving Videos..." -ForegroundColor Yellow
    copy-item -Path \\$sdevice\C$\Users\$user\Videos -Destination \\$ddevice\c$\$user-migrated -Recurse
        write-host "Moving Music..." -ForegroundColor Yellow
    copy-item -Path \\$sdevice\C$\Users\$user\Music -Destination \\$ddevice\c$\$user-migrated -Recurse
    write-host "All done. ${user}'s files can be found at C:\$user-migrated on the destination device." -ForegroundColor Green
    } else {
    $pick = read-host "Please provide the file path on the source device. C:\" 
    if (!(test-path \\$sdevice\C$\$pick)) {
        write-host "File path invalid. Exiting..."
        } else {
        mkdir \\$ddevice\c$\$user-migrated
        write-host "Moving ${pick}..." -ForegroundColor Yellow
        copy-item -Path \\$sdevice\C$\$pick -Destination \\$ddevice\c$\$user-migrated -Recurse
        write-host "All done." -ForegroundColor Green
        }
}