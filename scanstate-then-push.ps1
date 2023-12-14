#Requires -RunAsAdministrator
$warning = read-host "INSTRUCTIONS`n`nThis script must be run locally on the old/source device. When prompted, provide the name of the destination/new device. `nAfterwards, you must run the loadstate on the new device. Press ENTER to continue"
#Check for existing local store folders.
get-date
${fileserver} = read-host "Please provide the name of the file server."
#check for preexisting store file on local machine
if (test-path c:\store) {
    ${locl} = read-host "There is an existing store file on this device's C:\ drive. Overwrite? (Y/N)"
    if (${locl} -eq "y"){
        write-host "Deleting c:\store file...`n" -ForegroundColor Yellow
        remove-item c:\store -recurse
        } else {
        write-host "Store file untouched. Please move it elsewhere, then try again." -ForegroundColor Yellow
        exit
        }
}
#test connection to file server
if (!(test-connection -computername ${fileserver} )){
    write-host "       _____          ____`n" -ForegroundColor Yellow
    write-host "    _ / ___/ OFFLINE /___`n"-ForegroundColor Yellow
    write-host "   / /|/`n"-ForegroundColor Yellow
    write-host "  |_|_/`n"-ForegroundColor Yellow
    write-host "  |_ _|/`n"-ForegroundColor Yellow
    write-host "  |_|/`n`n"-ForegroundColor Yellow
    write-host "File server unavailable. Are you online?`n" -ForegroundColor Red
    exit
} else {
write-host "       __________________________" -ForegroundColor Green
write-host "    _ / _____FILE SERVER ONLINE__" -ForegroundColor Green
write-host "   / /|/" -ForegroundColor Green
write-host "  |_|_/" -ForegroundColor Green
write-host "  |_ _|/" -ForegroundColor Green
write-host "  |_|/`n" -ForegroundColor Green
}
#test connection to destination

$target = read-host "Destination Device Name"
if (test-connection -count 1 $target){
    write-host ${target} -ForegroundColor Yellow
    write-host " ______________" -ForegroundColor Green
    write-host "||            ||" -ForegroundColor Green
    write-host "||   0    0   ||" -ForegroundColor Green
    write-host "||            ||" -ForegroundColor Green
    write-host "||   \____/   ||" -ForegroundColor Green
    write-host "||____________||" -ForegroundColor Green
    write-host "|______________|" -ForegroundColor Green
    write-host " \\############\\" -ForegroundColor Green
    write-host "  \\############\\" -ForegroundColor Green
    write-host "   \      ____    \  " -ForegroundColor Green 
    write-host "    \_____\___\____\`n" -ForegroundColor Green
    write-host "Connection to ${target} is good. Beginning migration.`n" -ForegroundColor Green
    #put the location of the loadstate file here V
    copy-item -path \\scanstatefile\location\here -destination \\${target}\c$

} else {
    write-host " ______________" -ForegroundColor Yellow
    write-host "||            ||" -ForegroundColor Yellow
    write-host "||  X     X   ||" -ForegroundColor Yellow
    write-host "||            ||" -ForegroundColor Yellow
    write-host "||    ----    ||" -ForegroundColor Yellow
    write-host "||____________||" -ForegroundColor Yellow
    write-host "|______________|" -ForegroundColor Yellow
    write-host " \\############\\" -ForegroundColor Yellow
    write-host "  \\############\\" -ForegroundColor Yellow
    write-host "   \      ____    \   " -ForegroundColor Yellow
    write-host "    \_____\___\____\`n" -ForegroundColor Yellow
    write-host "      ${target} not found. Verify it is powered on and online.`n" -ForegroundColor Red
    exit
#prepare directories on both devices
}

if (test-path \\${target}\c$\loadstate){
    write-host "Loadstate found on ${target}. Deleting...`n" -ForegroundColor Yellow
    remove-item \\$target\c$\loadstate -recurse
    write-host "Rebuilding loadstate directory on ${target}...`n" -ForegroundColor Yellow
    mkdir \\${target}\c$\loadstate
    #provide path to usmt files
    copy-item -Path \\file\location\here -destination \\${target}\c$\loadstate
    } else {
    write-host "Creating loadstate directory...`n" -ForegroundColor Yellow
    mkdir \\${target}\c$\loadstate
    #provide path to usmt files
    copy-item -Path \\file\location\here -destination \\${target}\c$\loadstate
}
#remove any existing store files on destination, if desired
if (test-path \\$target\c$\store){
    ${del} = read-host "Found existing store file on ${target}`s C:\ drive. Overwrite? (Y/N)"
    if ( ${del} -eq "y" ) {
    write-host "Deleting ${target}'s store file...`n" -ForegroundColor Yellow
    remove-item \\${target}\c$\store -Recurse
    } else {
    write-host "Keeping existing store file. Exiting...`n" -ForegroundColor Yellow
    exit
    }
        cd c:\
#remove existing scanstate files on source just in case && begin building store file
        if (test-path c:\scanstate){
        write-host "Rebuilding local scanstate directory..." -ForegroundColor Yellow
        remove-item c:\scanstate -recurse
        mkdir c:\scanstate
        #provide path to usmt files
        copy-item -Path \\file\location\here -destination c:\scanstate
        cd c:\scanstate
        write-host "Building migration bundle...`n" -ForegroundColor Yellow
        .\scanstate.exe c:\store /i:migdocs.xml /i:migapp.xml /uel:30 /ue:*.* /c /o
        get-date
        write-host "Begining data transfer...`n" -ForegroundColor Yellow
        copy-item -path c:\store -destination \\$target\c$ -recurse
        write-host "Migration Complete. Please run loadstate on new device." -ForegroundColor Green
        get-date
        } else {
        mkdir c:\scanstate
        mkdir c:\store
        #provide path to usmt files
        copy-item -Path \\file\location\here -destination c:\scanstate
        cd scanstate
        write-host "Building migration bundle...`n" -ForegroundColor Yellow
        .\scanstate.exe c:\store /i:migdocs.xml /i:migapp.xml /uel:30 /ue:*.* /c /o
        get-date
        write-host "Begining data transfer...`n" -ForegroundColor Yellow
        copy-item -path c:\store -destination \\$target\c$ -recurse
        write-host "Migration Complete. Please run loadstate on new device." -ForegroundColor Green
        get-date
        }
#if no store files are found on remote device
} else {
    if (test-path c:\scanstate){
        write-host "Rebuilding scanstate directory..." -ForegroundColor Yellow
        remove-item c:\scanstate -recurse
        mkdir c:\scanstate
        mkdir c:\store
        #provide path to usmt files
        copy-item -Path \\file\location\here -destination c:\scanstate
        cd c:\scanstate
        write-host "Building migration bundle...`n" -ForegroundColor Yellow
        .\scanstate.exe c:\store /i:migdocs.xml /i:migapp.xml /uel:30 /ue:*.* /c /o
        get-date
        write-host "Begining data transfer...`n" -ForegroundColor Yellow
        copy-item -path c:\store -destination \\$target\c$ -recurse
        write-host "Migration Complete. Please run loadstate on new device." -ForegroundColor Green
        get-date
        } else {
        cd c:\
        mkdir c:\scanstate
        mkdir c:\store
        #provide path to usmt files
        copy-item -Path \\file\location\here -destination c:\scanstate
        cd c:\scanstate
        write-host "Building migration bundle...`n" -ForegroundColor Yellow
        .\scanstate.exe c:\store /i:migdocs.xml /i:migapp.xml /uel:30 /ue:*.* /c /o
        get-date
        write-host "Begining data transfer...`n" -ForegroundColor Yellow
        copy-item -path c:\store -destination \\$target\c$ -recurse
        get-date
        write-host "Migration Complete. Please run loadstate on new device." -ForegroundColor Green
    }
}
