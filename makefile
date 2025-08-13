SHELL:=/bin/bash

Installation: endec.sh
		@printf "\nUpdating Packages...\n"
		@sudo apt update
		@ExitStatus=$$?; \
		
		@if [[ $$ExitStatus -eq 0 ]]; then \
			printf "Packages updated successfully...\n"; \
			sleep 1; \
		else \
			printf "Something went wrong with package update\nExiting...\n"; \
			exit 1; \
		fi \
		
		@printf "\nInstalling 'tar' & 'gpg', if not installed already...\n" 
		@sudo apt install tar gpg -y
		@ExitStatus=$$?; \
		
		@if [[ $$ExitStatus -eq 0 ]]; then \
			printf "Successful...\n"; \
			sleep 1; \
		else \
			printf "Something went wrong with installing 'tar' and/or 'gpg'\nExiting...\n"; \
			exit 1; \
		fi \
		
		@printf "\nCopying endec.sh from ./ to /usr/local/bin/ \n"  
		@sudo cp ./endec.sh /usr/local/bin/
		@ExitStatus=$$?; \
		
		@if [[ $$ExitStatus -eq 0 ]]; then \
			printf "Copied successfully...\n"; \
			sleep 1; \
		else \
			printf "Something went wrong when copying 'endec.sh' to /usr/local/bin \nExiting...\n"; \
			exit 1; \
		fi \
		
		@printf "Renaming /usr/local/bin/endec.sh to /usr/local/bin/endec \n"
		@sudo mv /usr/local/bin/endec.sh /usr/local/bin/endec 
		@ExitStatus=$$?; \
		
		@if [[ $$ExitStatus -eq 0 ]]; then \
			printf "Renamed successfully...\n"; \
			sleep 1; \
		else \
			printf "Something went wrong when renaming 'endec.sh' to 'endec' \nExiting...\n"; \
			exit 1; \
		fi \
		
		@printf "Changing file permissions to -rwxr-xr-x \n"
		@sudo chmod 755 /usr/local/bin/endec
		@ExitStatus=$$?; \
		
		@if [[ $$ExitStatus -eq 0 ]]; then \
			printf "Permissions applied successfully...\n"; \
			sleep 1; \
		else \
			printf "Something went wrong when changing file permissions \nExiting...\n"; \
			exit 1; \
		fi \
		
		@printf "'endec' can now be run as command... Done\n"
		@printf "Type: 'endec -h' , for more info...\n"
