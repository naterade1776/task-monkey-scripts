# task-monkey-scripts
A collection of PowerShell scripts to make IT's job easier.

All scripts designed for an admin in an AD-Domain environment.

group-member-finder
	
	Finds all members of an AD group and spits out a csv file into the working directory.

file-mover

	Copies a user's common folders on one device to a single folder on another device's C drive. One can also chose to provide
	the path of a specified file or folder.

messenger

	Sends a simple pop-up message to a remote device.


remote-scanstate-v2

	Runs USMT's scanstate on the local machine and copies the 'store' file to the new device's C drive. Depending on your environment,
	you may even be able to run loadstate remotely as well. Be sure to read the comments and put in necessary file paths. 
