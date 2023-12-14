cd c:
${grp} = Read-Host "Group Name"
$mem = Get-ADGroupMember -identity ${grp} |
    foreach-object {
        get-aduser $_ -properties emailaddress
        }
$mem | export-csv -path .\${grp}-members.csv -notypeinformation -append
get-content -path .\${grp}-members.csv