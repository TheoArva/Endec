#!/bin/bash

function nameinput { #Ask user to enter file's or folder's name

printf "\nEnter file/folder name or full PATH:\n"
read response

}

################################DECRYPT & UNZIP#################################

function merge01 { #Ask user for file name, decrypt given filename & force system to forget password. Redirect SDTERR to file & STDOUT to null.

nameinput; gpg -o "$response".tar.gz -d "$response" 2> ~/.endecSTDERR.txt 1> /dev/null && gpgconf --reload gpg-agent

}

function unzel { #Extract zipped file to current dir & delete it.

tar -xzvf "$response".tar.gz -C ./;

printf "\nOriginal encrypted file can be deleted.\nDelete it, permanently: (y/n)? "

rm -r "$response".tar.gz; rm -rI "$response"

}

function decexitcode { #Filter exit error of function 'merge01' from SDTERR file and proceed with either funtion 'nxpassloop' for incorrect password entered,>> 
# >> or 'nxnameloop' function for incorrect name entered. Look at their descriptions below for more info.  

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

function nxpassloop { #Loop asking user to try again with correct password for decrypted file. If password is incorrect again, loop will repeat >> 
# >> twice + 1 from initial prompt to enter password = 3, overall for user. >> 
# >> Loop will break if correct password is provided. Ending with filtering the error text file to end the function with exit status, >> 
# >> or  with 'unzel' to unzip and delete zipped file, if correct password is provided.

i=0

printf "\nIncorrect Password! Try again...\n"; sleep 1

ino () {
	gpgconf --reload gpg-agent; gpg -o "$response".tar.gz -d "$response" 2> /dev/null 1> /dev/null 2> ~/.endecSTDERR.txt && gpgconf --reload gpg-agent

}

ino

while [[ $? -ne 0 ]]
do	
	while [[ $i -lt 1 ]]
	do
		 printf "\nIncorrect Password! Try again...\n\a" && sleep 1 && ino
		((i++))
	done	
	if [[ $? -eq 0 ]]
	then 
		break
	fi	
done

cat ~/.endecSTDERR.txt | grep -i "decryption failed" 2> /dev/null 1> /dev/null

if [[ $? -eq 0 ]]
then
	printf "\nIncorrect Password!\n\nFailed attempt... Halt!\n\a" 
else
       unzel 2> /dev/null
fi

}

function nxnameloop { #Loop asking user to try with correct filename again. If filename is incorrect again, loop will repeat twice + 1 from initial prompt >>
# >> to enter filename = 3, overall for user. Loop will break if correct filename is given, or correct filemame+correct password, >> 
# >> or correct filename+incorrect password. Ending these 3 scenarios with triple OR statement that filters them and provides an ending for each one of them. >> 
# >> Scenario of incorrect filename+incorrect password is redirected to the nxpassloop.

por () {

cat ~/.endecSTDERR.txt | grep -i "no such file" 2> /dev/null 1> /dev/null

if [[ $? -eq 0 ]]
then
	printf "\n\t!!!File or Folder does NOT exist!!!\n\nFailed Attempt! Halt!\n\a" 
else
	return 1

fi

rm -r ~/.endecSTDERR.txt

}

por2 () {

cat ~/.endecSTDERR.txt | grep -i "decryption failed" 2> /dev/null 1> /dev/null

if [[ $? -eq 0 ]]
then 
	nxpassloop
else
	return 1
fi

rm -r ~/.endecSTDERR.txt

}

nor () {

gpgconf --reload gpg-agent; nameinput &&  gpg -o "$response".tar.gz -d "$response" 2> /dev/null 1> /dev/null 2> ~/.endecSTDERR.txt && gpgconf --reload gpg-agent;

cat ~/.endecSTDERR.txt | grep -i "no such file" 2> /dev/null 1> /dev/null

if [[ $? -eq 0 ]]
then
	return 1
elif [[ $? -ne 0 ]]
then
	return 0
fi

}

i=0

printf "\n\t!!!File or Folder does NOT exist!!!\n\a"

nor 

while [[ $? -ne 0 ]]
do
	while [[ $i -lt 1 ]]
	do
		printf "\n\t!!!File or Folder does NOT exist!!!\n\a"; nor
		((i++))
	done
	if [[ $? -eq 0 ]]
	then
		return 0
	fi

done	

por || por2 || unzel 2> /dev/null

}

function uncrypt { #Final script for Decrypt and Unzip. If above funtion 'merge01' is successful, then unzip file & end script. >> 
# >> If unsuccessful, filter error accordingly to decide for next step. Look function's 'decexitcode' description above for more info.

merge01

if [[ $? -eq 0 ]]
then
	unzel
else
	decexitcode
fi

}

################################ZIP & ENCRYPT#################################

function encrypt { #Encrypt zipped file & force system to "forget" password

gpg --symmetric --cipher-algo AES256 "$response2".tar.gz 

gpgconf --reload gpg-agent

}

function zip { # If filename entered is incorrect or doesn't exist, create dummy file & return 1. >> 
# >> Otherwise proceed with prompting user to enter new filename & zipping.

ls -a ./ | grep -x "$response" 2> /dev/null 1> /dev/null

if [[ $? -ne 0 ]]
then
	touch ~/.endecSTDERR.txt; return 1
else
	printf "Enter new name of zipped file '*.tar.gz'\n"; read response2; tar -czvf "$response2".tar.gz "$response" 2> /dev/null

fi

}

function finder { #Look for dummy file created only when incorrect filename was entered previously.

ls -la ~/ | grep -i "endecSTDERR.txt" 1> /dev/null 2> /dev/null

if [[ $? -eq 0 ]]
then
	printf "\n\t!!!File or Folder does NOT exist!!!\n\n\a" ; rm -r ~/.endecSTDERR.txt
else
	return 0
fi

}

function merge02 { #Prompt user to enter filename & use function 'zip'. See above for info about 'zip'.

nameinput && zip

}

function loopa { #Loop checking if filename entered by user exists or not, using the function 'finder'. Loop will break if correct filename is given. >> 
# >> Ending function with 'finder' to filter incorrect last filename entered, or if a dummy STDERR file doesn't exist, script will proceed >> 
# >> with function 'encrypt' &  prompt user to delete, or not, original file/folder & its zipped file. Look above for more info about 'ecrypt'.

i=0

merge02

while [[ $? -ne 0 ]]
do	
	while [[ $i -lt 1 ]]
	do
		finder; merge02 
		((i++))		
	done
	if [[ $? -eq 0 ]]
	then
		return 0
	fi
done	

ls -la ~/ | grep -i "endecSTDERR.txt" 1> /dev/null 2> /dev/null

if [[ $? -eq 0 ]]
then
	printf "\n\t!!!File or Folder does NOT exist!!!\n\n\a" ;  rm -r ~/.endecSTDERR.txt 2> /dev/null
else
	encrypt 1> /dev/null 2> /dev/null && printf "\nOriginal file/folder & its zipped '.*tar.gz' file can be deleted.\nDelete them, permanently: (y/n) ?\n"; rm -rI "$response" "$response2".tar.gz

fi

}

function zipcrypt { #Final script to Zip & Encrypt file/folder, prompt user to delete, or not, original file/folder & its zipped file

merge02

if [[ $? -eq 0 ]]
then
	encrypt; printf "\nOriginal file/folder & its zipped '*.tar.gz' file can be deleted.\nDelete them, permanently: (y/n) ?\n"; rm -rI "$response" "$response2".tar.gz
else
	finder; sleep 1; loopa
fi

}

###############################Final Script#####################################


#Makefile must be run to install endec!
#Run: bash endec.sh to launch info about how to run makefile.

#Created a makefile to install 'gpg' & 'tar', rename endec.sh to endec, turn endec to an exec file, and move it to /usr/bin to run it as a command.

sudo find /usr/bin -name "endec" > ~/.endecInstall.txt         #These 2 first lines will look for an 'endec' file in /usr/bin and redirect result to a SDTOUT file.
cat ~/.endecInstall.txt | grep -i "endec" > /dev/null           

if [[ $? -eq 0 ]]						#If SDTOUT file doesn't include the word 'endec', user will be advised to launch makefile to install endec; 
								# >> instructions are included; run 'bash endec.sh' to see instructions
then	
	if [[ $1 =~ "-en" ]]
	then
		zipcrypt; rm -r ~/.endecSTDERR.txt 2> /dev/null
	elif [[ $1 =~ "-de" ]]
	then							#After makefile is launched and complete, type: endec -h for more info about options
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
################################THE END###############################################
