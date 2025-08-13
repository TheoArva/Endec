#!/bin/bash

#Endec (v1.0)
#Copyright (C) 2021 Theodoros Arvanitis (Author)
#This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.
#This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/
#Email: theodorosarv@gmail.com

nameinput() { #prompt user to type file/folder name for encrypting & zipping / unzipping & decrypting

	printf "\nEnter file or folder name:\n"
	IFS= read -r response

}

promptdelete() { #prompt user to select whether to permanent delete initial encrypted '*.tar.gz.gpg' file & its decrypted+zipped '*.tar.gz' file after successfully unzipping & decrypting it, or not

	i=1

	printf "\nOriginal file/folder & its zipped '.*tar.gz' file can be deleted.\nDelete them, permanently: (y/n) ?";

	IFS=read -r response3

		if [[ "$response3" =~ [yY] ]]
		then
			rm -r -f --interactive=never "$response" && rm -r -f --interactive=never "$response2".tar.gz && rm -r -f --interactive=never "${response%.gpg}"
		elif [[ "$response3" =~ [nN] ]]
		then
			return 0
		elif [[ "$response3" != [yYnN] ]]
		then
			while [[ $i -le 2 ]]
			do
				printf ""$response3" is invalid.\nPlease enter y/Y for Yes, or n/N for No\n";
				touch -f ~/.endecSTDERR.txt;
				IFS= read -r response3;
				if [[ "$response3" =~ [nN] ]]
				then
					rm -rf ~/.endecSTDERR.txt 2> /dev/null;
					break
				elif [[ "$response3" =~ [yY] ]]
				then
					rm -r -f --interactive=never "$response" && rm -r -f --interactive=never "$response2".tar.gz && rm -r -f --interactive=never "${response%.gpg}"
					rm -rf ~/.endecSTDERR.txt 2> /dev/null;
					break
				fi
				((i++))
			done
			ls -la ~/ | grep -i "endecSTDERR.txt" 1> /dev/null 2> /dev/null
			if [[ $? -eq 0 ]]
			then
        		printf ""$response3" is invalid.\n";
				printf "Failed Attempt! No files were deleted!\n";
        		rm -rf ~/.endecSTDERR.txt 2> /dev/null;
			else
        		return 0

			fi
	fi

}

unzel() { #unzip decrypted 'tar.gz' file & prompt user to select whether to permanent delete initial encrypted '*.tar.gz.gpg' file & its decrypted+zipped '*.tar.gz' file after successfully unzipping & decrypting it, or not

	tar -xzvf "${response%.gpg}" -C ./ && promptdelete

}

decreload() { #clear the SHELL from any pre-entered passwds used w/ 'gpg' to decrypt files & passing any STDERR to a dummy, hidden, temp file for read use
	
 	gpgconf --reload gpg-agent; 
 	gpg -o "${response%.gpg}" -d "$response" 1> /dev/null 2> ~/.endecSTDERR.txt && gpgconf --reload gpg-agent

}

nxpassloop() { #activated when user enters an incorrect passwd for decrypting the '*.tar.gz.gpg' file by informing user for their incorrect passwd input & giving them up to 3 tries for passwd re-entering

	i=1

	printf "\nIncorrect Password! Try again...\n";
	sleep 1;
	decreload;
		if [[ $? -ne 0 ]]
		then	
			while [[ $i -lt 2 ]]
			do
				printf "\nIncorrect Password! Try again...\n\a";
				sleep 1;
				decreload;
					if [[ $? -eq 0 ]]
					then
						break
					fi
					((i++))
			done	
			cat ~/.endecSTDERR.txt | grep -i "decryption failed" &> /dev/null;
				if [[ $? -eq 0 ]]
				then
					printf "\nIncorrect Password!\nFailed attempt... Halt!\n\a" 
				else
					unzel 2> /dev/null

				fi
		else
			unzel 2> /dev/null
		fi

}

newnamezipcrypt() { #prompt user to enter a name for the newly created zipped+encrypted file & zip+encrypt the user-selected file/folder

	printf "Enter new name of zipped file '*.tar.gz'\n";
	IFS= read -r response2;
	tar -czvf "$response2".tar.gz "$response" 2> /dev/null;
	gpg --symmetric --cipher-algo AES256 "$response2".tar.gz;
	gpgconf --reload gpg-agent;

}

uncrypt() { #final function unzipping & decrypting the user-selected '*.tar.gz.gpg' file by combining all related previous functions

	i=1

	nameinput;
	ls -a ./ | grep -x "$response" &> /dev/null
		if [[ $? -eq 0 ]]
		then
        	decreload;
        	unzel 2> /dev/null;
        	cat ~/.endecSTDERR.txt | grep -i "decryption failed" &> /dev/null;
        		if [[ $? -eq 0 ]]
        		then
                	nxpassloop
        		else
                	return 0
        		fi
		else 
        	while [[ $i -lt 3 ]]
        	do
                printf "\nFile or Folder does NOT exist, or it's a file w/o a '*.tar.gz.gpg' extension!\n";
                sleep 1;
                touch -f ~/.endecSTDERR.txt;
                nameinput;
                ls -a ./ | grep -x "$response" &> /dev/null;
					if [[ $? -eq 0 ]]
                	then
                        rm -rf ~/.endecSTDERR.txt 2> /dev/null;
                        decreload;
                        unzel 2> /dev/null;
                        break
                	fi
                	((i++))
        	done
        	cat ~/.endecSTDERR.txt | grep -i "decryption failed" &> /dev/null;
        		if [[ $? -eq 0 ]]
        		then
                	nxpassloop
        		else
                	ls -la ~/ | grep -i "endecSTDERR.txt" &> /dev/null
                		if [[ $? -eq 0 ]]
                		then
                        	printf "\nFile or Folder does NOT exist, or it's a file w/o a '*.tar.gz.gpg' extension\n";
                        	printf "\nFailed Attempt! Halt!\n";
                        	rm -rf ~/.endecSTDERR.txt 2> /dev/null;
                		else
                        	return 0
                		fi
        		fi
		fi

}

zipcrypt() { #final function zipping & encrypting the user-selected file/folder by combining all related previous functions

	i=1

	nameinput;
	ls -a ./ | grep -x "$response" &> /dev/null
		if [[ $? -eq 0 ]]
		then
        	newnamezipcrypt;
        	promptdelete;
		else
        	while [[ $i -lt 3 ]]
        	do
                printf "\nFile or Folder does NOT exist!\n";
                sleep 1;
				touch -f ~/.endecSTDERR.txt;
                nameinput;
                ls -a ./ | grep -x "$response" &> /dev/null;
                	if [[ $? -eq 0 ]]
                	then
                        	newnamezipcrypt;
							rm -rf ~/.endecSTDERR.txt 2> /dev/null;
                        	promptdelete;
                        	break
                	fi
                	((i++))
        	done
			ls -la ~/ | grep -i "endecSTDERR.txt" &> /dev/null
				if [[ $? -eq 0 ]]
				then
        			printf "\nFile or Folder does NOT exist!\n";
					printf "\nFailed Attempt! Halt!\n";
        			rm -rf ~/.endecSTDERR.txt 2> /dev/null;
				else
        			return 0
				fi
		fi

}

sudo find /usr/local/bin/ -name "endec" > ~/.endecInstall.txt; #checks whether the final 'endec' exec file exists in '/usr/local/bin' path & if it is, pass it to a dummy, temp, hidden file
cat ~/.endecInstall.txt | grep -i "endec" > /dev/null; # verify if the dummy, temp, hidden file includes 'endec' in it...
	if [[ $? -eq 0 ]] #if it does...
	then	
		if [[ $1 =~ ^"-en"$ ]] #...check for parameter $1 aka -en & initiate zipping+encrypting...
		then
			zipcrypt;
			rm -rf ~/.endecSTDERR.txt 2> /dev/null
		elif [[ $1 =~ ^"-de"$ ]] #...check for parameter $1 aka -de & initiate unzipping+decrypting...
		then
			uncrypt;
			rm -rf ~/.endecSTDERR.txt 2> /dev/null
		elif [[ $1 =~ ^"--uninstall"$ ]] #...check for parameter $1 aka --uninstall & initiate removal of 'endec' permantently from '/user/local/bin/' path immitating an uninstallation behaviour...
		then
			sudo rm -rf /usr/local/bin/endec
		elif [[ $1 =~ ^"--help"$ ]] || [[ $1 =~ ^"-h"$ ]] #check for parameter $1 aka -h or --help & inform the user about howto use the 'endec' exec...
		then
			printf "Usage:\nendec [OPTIONS]...\n\nZip a file/folder & Ecrypt it.\n\nand/or\n\nDecrypt a file/folder & Unzip it.\n \nNOTE: Run 'endec' within the PATH of file/folder in question.\n \nOptions:\n\n  -en \t \t Zip & Encrypt\n \n  -de \t \t Decrypt & Unzip\n \n  --uninstall \t Uninstall (Delete 'endec' from /usr/bin, permanently)\n \n  -h, --help\t Show this message\n\n\n"
		else #...check for parameter $1 & if it's not one of -en, -de, --uninstall, -h, --help, then briefly inform the user about proper input for $1...
			printf "\noptions: -en, -de, or -h, --help for info\n\n" 
		fi
	else #if it does NOT, inform the user about proper steps for installation
		printf "\nRun 'makefile' to install.\n\nType:\n\nmake\n\nand hit Enter.\n(you must be within the same dir as 'makefile' & 'endec.sh'.)\n\nInfo:\n\nmakefile \tInstalls 'gpg' & 'tar', makes endec.sh executable,\n \t \tmoves it /usr/local/bin to run it as command\n\n" 
rm -rf ~/.endecInstall.txt
