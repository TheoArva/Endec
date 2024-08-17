#!/bin/bash

nameinput() {

printf "\nEnter file or folder name:\n"
read response

}

promptdelete() {

i=1

read response3

if [[ $response3 =~ [yY] ]]
then
	rm -r -f --interactive=never "$response" && rm -r -f --interactive=never "$response2".tar.gz && rm -r -f --interactive=never "${response%.gpg}"
elif [[ $response3 =~ [nN] ]]
then
	return 0
elif [[ $response3 != [yYnN] ]]
then
	while [[ $i -le 3 ]]
	do
		printf ""$response3" is invalid.\nPlease enter y/Y for Yes, or n/N for No\n";
		read response3;
		if [[ $response3 =~ [nN] ]]
		then
			break
		elif [[ $response3 =~ [yY] ]]
		then
			rm -r -f --interactive=never "$response" && rm -r -f --interactive=never "$response2".tar.gz && rm -r -f --interactive=never "${response%.gpg}"
			break
		fi
		((i++))
	done
fi

}

merge01() {

nameinput; gpg -o "${response%.gpg}" -d "$response" 2> ~/.endecSTDERR.txt 1> /dev/null && gpgconf --reload gpg-agent

}

unzel() {

tar -xzvf "${response%.gpg}" -C ./;

printf "\nOriginal encrypted file & its decrypted zipped file can be deleted.\nDelete them, permanently:(y/n)? "; promptdelete

}

decexitcode() {

if [[ $? -ne 0 ]]
then
	cat ~/.endecSTDERR.txt | grep -i "decryption failed" 1> /dev/null 2> /dev/null
	if [[ $? -eq 0 ]]
	then
		sleep 1; nxpassloop
	else
		nxnameloop
	fi
else
	return 0
fi

}

nxpassloop() {

i=1

printf "\nIncorrect Password! Try again...\n"; sleep 1

ino() {
	gpgconf --reload gpg-agent; gpg -o "${response%.gpg}" -d "$response" 2> /dev/null 1> /dev/null 2> ~/.endecSTDERR.txt && gpgconf --reload gpg-agent

}

ino

if [[ $? -ne 0 ]]
then	
	while [[ $i -lt 3 ]]
	do
		 printf "\nIncorrect Password! Try again...\n\a" && sleep 1 && ino
		 ((i++))
	done	
else 
	return 0
fi

cat ~/.endecSTDERR.txt | grep -i "decryption failed" 2> /dev/null 1> /dev/null

if [[ $? -eq 0 ]]
then
	printf "\nIncorrect Password!\n\nFailed attempt... Halt!\n\a" 
else
       unzel 2> /dev/null
fi

}

nxnameloop() {
	
por() {

cat ~/.endecSTDERR.txt | grep -i "no such file" 2> /dev/null 1> /dev/null

if [[ $? -eq 0 ]]
then
	printf "\n\t!!!File or Folder does NOT exist!!!\n\nFailed Attempt! Halt!\n\a" 
else
	return 1

fi

rm -r ~/.endecSTDERR.txt

}

por2() {

cat ~/.endecSTDERR.txt | grep -i "decryption failed" 2> /dev/null 1> /dev/null

if [[ $? -eq 0 ]]
then 
	nxpassloop
else
	return 1
fi

rm -r ~/.endecSTDERR.txt

}

nor() {

gpgconf --reload gpg-agent; nameinput &&  gpg -o "${response%.gpg}" -d "$response" 2> /dev/null 1> /dev/null 2> ~/.endecSTDERR.txt && gpgconf --reload gpg-agent;

cat ~/.endecSTDERR.txt | grep -i "no such file" 2> /dev/null 1> /dev/null

if [[ $? -eq 0 ]]
then
	return 1
elif [[ $? -ne 0 ]]
then
	return 0
fi

}

i=1

printf "\n\t!!!File or Folder does NOT exist!!!\n\a"

nor 

if [[ $? -ne 0 ]]
then
	while [[ $i -lt 3 ]]
	do
		printf "\n\t!!!File or Folder does NOT exist!!!\n\a"; nor
		((i++))
	done
else
	return 0
fi
	
por || por2 || unzel 2> /dev/null 

}

uncrypt() { 

merge01

if [[ $? -eq 0 ]]
then
	unzel
else
	decexitcode
fi

}

encrypt() { 

gpg --symmetric --cipher-algo AES256 "$response2".tar.gz 

gpgconf --reload gpg-agent

}

zip() {

ls -a ./ | grep -x "$response" 2> /dev/null 1> /dev/null

if [[ $? -ne 0 ]]
then
	touch ~/.endecSTDERR.txt; return 1
else
	printf "Enter new name of zipped file '*.tar.gz'\n"; read response2; tar -czvf "$response2".tar.gz "$response" 2> /dev/null

fi

}

finder() {

ls -la ~/ | grep -i "endecSTDERR.txt" 1> /dev/null 2> /dev/null

if [[ $? -eq 0 ]]
then
	printf "\n\t!!!File or Folder does NOT exist!!!\n\n\a" ; rm -r ~/.endecSTDERR.txt
else
	return 0
fi

}

merge02() {

nameinput && zip

}

loopa() {

i=1

merge02

if [[ $? -ne 0 ]]
then	
	while [[ $i -lt 3 ]]
	do
		finder; merge02 
		((i++))		
	done
else
	return 0
fi	

ls -la ~/ | grep -i "endecSTDERR.txt" 1> /dev/null 2> /dev/null

if [[ $? -eq 0 ]]
then
	printf "\n\t!!!File or Folder does NOT exist!!!\n\n\a" ;  rm -r ~/.endecSTDERR.txt 2> /dev/null
else
	encrypt 1> /dev/null 2> /dev/null && printf "\nOriginal file/folder & its zipped '.*tar.gz' file can be deleted.\nDelete them, permanently: (y/n) ?"; promptdelete 

fi

}

zipcrypt() {

merge02

if [[ $? -eq 0 ]]
then
	encrypt; printf "\nOriginal file/folder & its zipped '*.tar.gz' file can be deleted.\nDelete them, permanently: (y/n) ?"; promptdelete
else
	finder; sleep 1; loopa
fi

}

sudo find /usr/bin -name "endec" > ~/.endecInstall.txt
cat ~/.endecInstall.txt | grep -i "endec" > /dev/null           

if [[ $? -eq 0 ]]
then	
	if [[ $1 =~ "-en" ]]
	then
		zipcrypt; rm -r ~/.endecSTDERR.txt 2> /dev/null
	elif [[ $1 =~ "-de" ]]
	then
		uncrypt; rm -r ~/.endecSTDERR.txt 2> /dev/null
	elif [[ $1 =~ "-ui" ]]
	then
		sudo rm -r /usr/bin/endec	
	elif [[ $1 =~ "--help" ]] || [[ $1 =~ "-h" ]]
	then
		printf "Usage:\nendec [OPTIONS]...\n\nZip a file/folder & Ecrypt it.\nand/or\nDecrypt a file/folder & Unzip it.\n \nNOTE: Best to launch 'endec' within the PATH of file/folder in question.\n \nOptions:\n\n  -en \t \t Zip & Encrypt\n \n  -de \t \t Decrypt & Unzip\n \n  -ui \t \t Uninstall(Delete endec from /usr/bin, permanently)\n \n  -h, --help\t Show this message\n\n\n"
	elif [[ $1 =~ "" ]] && [[ $1 != "-en" ]] && [[ $1 != "-de" ]] && [[ $1 != "-h" ]] && [[ $1 != "--help" ]]
	then
		printf "\noptions: -en, -de, or -h, --help for info\n\n"
	fi
else 
	printf "\nRun 'makefile' to install.\n\nType:\n\nmake\n\nand hit Enter.\n(you must be within the same dir as 'makefile' & 'endec.sh'.)\n\nInfo:\n\nmakefile \tInstalls 'gpg' & 'tar', makes endec.sh executable,\n \t \tmoves it /usr/bin to run it as command\n\n"

fi

rm -r ~/.endecInstall.txt
