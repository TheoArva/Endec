
Installation: endec.sh
		@printf "\nUpdating Package Info...\n"
		@sudo apt update
		@printf "\nInstalling 'tar' & 'gpg', if already not installed...\n" 
		@sudo apt install tar gpg -y
		@printf "Updating Package Info once again...\n"
		@sudo apt update
		@printf "\nCopying endec.sh from ./ to /usr/local/bin/...\n"
		@sudo cp ./endec.sh /usr/local/bin/
		@printf "Renaming /usr/local/bin/endec.sh to /usr/local/bin/endec...\n"
		@sudo mv /usr/local/bin/endec.sh /usr/local/bin/endec
		@printf "Changing file permissions to -rwxr-xr-x...\n"
		@sudo chmod 755 /usr/local/bin/endec
		@printf "'endec' can now be run as command...\n"
		@printf "Type: 'endec -h' , for more info...\n"
	
		
		
