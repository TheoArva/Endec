**Endec (v1.0)**

**Copyright (C) 2021 Theodoros Arvanitis (Author)**

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see [https://www.gnu.org/licenses/](https://www.gnu.org/licenses/)

Email: *theodorosarv@gmail.com*

## Endec ##

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

   for more information about available [OPTIONS]...

[^1]: *As 2 different words, separated by a space*

[^2]: *This will install **tar** & **gpg**, copy 'endec.sh' to /usr/bin, rename & turn it into an exec file, so user can run it as a system command.*

[^3]: *Installing ***make*** is the highest priority since ***tar*** & ***gpg*** will be installed, when running the ***makefile***.*
