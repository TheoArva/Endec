
Installation: endec.sh
		@printf "\nUpdating Package Info...\n"
		@sudo apt update
		@printf "\nInstalling 'tar' & 'gpg', if already not installed...\n" 
		@sudo apt install tar gpg -y
		@printf "Updating Package Info once again...\n"
		@sudo apt update
		@printf "\nCopying endec.sh from ./ to /usr/bin/... Done\n"
		@sudo cp ./endec.sh /usr/bin/
		@printf "Renaming /usr/bin/endec.sh to /usr/bin/endec... Done\n"
		@sudo mv /usr/bin/endec.sh /usr/bin/endec
		@printf "Changing file permissions to -rwxr-xr-x... Done\n"
		@sudo chmod 755 /usr/bin/endec
		@printf "'endec' can now be run as command... Done\n"
		@printf "Type: 'endec -h' , for more info...\n"
	
		
		
