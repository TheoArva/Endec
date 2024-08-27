#!/bin/bash

#Endec (v1.0)
#Copyright (C) 2021 Theodoros Arvanitis (Author)
#This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.
#This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/
#Email: theodorosarv@gmail.com

nameinput() {

printf "\nEnter file or folder name:\n"
read response

}

promptdelete() {

i=1

printf "\nOriginal file/folder & its zipped '.*tar.gz' file can be deleted.\nDelete them, permanently: (y/n) ?";

read response3

if [[ $response3 =~ [yY] ]]
then
	rm -r -f --interactive=never "$response" && rm -r -f --interactive=never "$response2".tar.gz && rm -r -f --interactive=never "${response%.gpg}"
elif [[ $response3 =~ [nN] ]]
then
	return 0
elif [[ $response3 != [yYnN] ]]
then
	while [[ $i -le 2 ]]
	do
		printf ""$response3" is invalid.\nPlease enter y/Y for Yes, or n/N for No\n";
		touch -f ~/.endecSTDERR.txt;
		read response3;
		if [[ $response3 =~ [nN] ]]
		then
			rm -rf ~/.endecSTDERR.txt 2> /dev/null;
			break
		elif [[ $response3 =~ [yY] ]]
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

unzel() {

tar -xzvf "${response%.gpg}" -C ./ && promptdelete

}

nxpassloop() {

ino() {
	gpgconf --reload gpg-agent; gpg -o "${response%.gpg}" -d "$response" 1> /dev/null 2> ~/.endecSTDERR.txt && gpgconf --reload gpg-agent

}

i=1

printf "\nIncorrect Password! Try again...\n";
sleep 1;
ino;
if [[ $? -ne 0 ]]
then	
	while [[ $i -lt 2 ]]
	do
		printf "\nIncorrect Password! Try again...\n\a";
		sleep 1;
		ino;
		if [[ $? -eq 0 ]]
		then
			break
		fi
		((i++))
	done	
	cat ~/.endecSTDERR.txt | grep -i "decryption failed" 2> /dev/null 1> /dev/null;
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

uncrypt() { 

i=1

nameinput;
ls -a ./ | grep -x "$response" 2> /dev/null 1> /dev/null

if [[ $? -eq 0 ]]
then
        gpg -o "${response%.gpg}" -d "$response" 2> ~/.endecSTDERR.txt 1> /dev/null && gpgconf --reload gpg-agent;
        unzel 2> /dev/null;
        cat ~/.endecSTDERR.txt | grep -i "decryption failed" 2> /dev/null 1> /dev/null;
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
                ls -a ./ | grep -x "$response" 2> /dev/null 1> /dev/null;
                if [[ $? -eq 0 ]]
                then
                        rm -rf ~/.endecSTDERR.txt 2> /dev/null;
                        gpg -o "${response%.gpg}" -d "$response" 2> ~/.endecSTDERR.txt 1> /dev/null && gpgconf --reload gpg-agent;
                        unzel 2> /dev/null;
                        break
                fi
                ((i++))
        done
        cat ~/.endecSTDERR.txt | grep -i "decryption failed" 2> /dev/null 1> /dev/null;
        if [[ $? -eq 0 ]]
        then
                nxpassloop
        else
                ls -la ~/ | grep -i "endecSTDERR.txt" 1> /dev/null 2> /dev/null
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

zipcrypt() {

zip() { 

printf "Enter new name of zipped file '*.tar.gz'\n";
read response2;
tar -czvf "$response2".tar.gz "$response" 2> /dev/null;
gpg --symmetric --cipher-algo AES256 "$response2".tar.gz;
gpgconf --reload gpg-agent;

}

i=1

nameinput;
ls -a ./ | grep -x "$response" 2> /dev/null 1> /dev/null

if [[ $? -eq 0 ]]
then
        zip;
        promptdelete;
else
        while [[ $i -lt 3 ]]
        do
                printf "\nFile or Folder does NOT exist!\n";
                sleep 1;
		touch -f ~/.endecSTDERR.txt;
                nameinput;
                ls -a ./ | grep -x "$response" 2> /dev/null 1> /dev/null;
                if [[ $? -eq 0 ]]
                then
                        zip;
			rm -rf ~/.endecSTDERR.txt 2> /dev/null;
                        promptdelete;
                        break
                fi
                ((i++))
        done
	ls -la ~/ | grep -i "endecSTDERR.txt" 1> /dev/null 2> /dev/null
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

sudo find /usr/bin -name "endec" > ~/.endecInstall.txt
cat ~/.endecInstall.txt | grep -i "endec" > /dev/null           

if [[ $? -eq 0 ]]
then	
	if [[ $1 =~ ^"-en"$ ]]
	then
		zipcrypt;
		rm -rf ~/.endecSTDERR.txt 2> /dev/null
	elif [[ $1 =~ ^"-de"$ ]]
	then
		uncrypt;
		rm -rf ~/.endecSTDERR.txt 2> /dev/null
	elif [[ $1 =~ ^"--uninstall"$ ]]
	then
		sudo rm -rf /usr/bin/endec	
	elif [[ $1 =~ ^"--help"$ ]] || [[ $1 =~ ^"-h"$ ]]
	then
		printf "Usage:\nendec [OPTIONS]...\n\nZip a file/folder & Ecrypt it.\n\nand/or\n\nDecrypt a file/folder & Unzip it.\n \nNOTE: Run 'endec' within the PATH of file/folder in question.\n \nOptions:\n\n  -en \t \t Zip & Encrypt\n \n  -de \t \t Decrypt & Unzip\n \n  --uninstall \t Uninstall (Delete 'endec' from /usr/bin, permanently)\n \n  -h, --help\t Show this message\n\n\n"
	else
		printf "\noptions: -en, -de, or -h, --help for info\n\n"
	fi
else 
	printf "\nRun 'makefile' to install.\n\nType:\n\nmake\n\nand hit Enter.\n(you must be within the same dir as 'makefile' & 'endec.sh'.)\n\nInfo:\n\nmakefile \tInstalls 'gpg' & 'tar', makes endec.sh executable,\n \t \tmoves it /usr/bin to run it as command\n\n"

fi

rm -rf ~/.endecInstall.txt
