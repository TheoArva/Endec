
Installation: endec.sh
		@printf "\nUpdating Package Info...\n"
		@sudo apt update
		@printf "\nInstalling 'tar' & 'gpg', if already not installed...\n" 
		@sudo apt install tar gpg -y
		@printf "Updating Package Info once again...\n"
		@sudo apt update
		@printf "\nRenaming endec.sh to endec... Done\n"
		@mv ./endec.sh ./endec
		@printf "Changing file permissions to -rwxr--r--... Done\n"
		@sudo chmod 744 ./endec
		@printf "Moving endec to /user/bin... Done\n"
		@sudo mv ./endec /usr/bin
		
