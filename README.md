# Endec.sh Readme

This is a script written in Shell/Bash, which allows user to:

1. Zip & Encrypt

     and

2. Decrypt & Uzip

  files and folders.

## Requirements:

- **tar**
- **gpg** 
- **make**[^3]

must be installed on system.

## How to start:

1. Download ***endec.sh*** & ***makefile*** to your computer.

2. Open Terminal & use **cd** command to go to the directory, where the files above are saved.

3. Type: 

bash endec.sh[^1]

and hit Enter.

4. Follow the instructions that appear about how to run the makefile for installation.[^2]

5. Once installation is complete, type:

endec -h[^1]

for more information about available OPTIONS.

[^1]: *as 2 different words, separated by a space.*

[^2]: *this will install **tar** & **gpg**, turn script into an executable file & move it to /usr/bin, so user can run it as a system command.*

[^3]: *Installing ***make*** is the highest priority since ***tar*** & ***gpg*** will be installed, when running the ***makefile***.*
