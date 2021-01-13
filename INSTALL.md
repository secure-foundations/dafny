Building on Linux
=================

Originally written for a fresh Ubuntu 16.04 image, updated by testing on Fedora 29. Note that we now have [official releases for Linux](https://github.com/dafny-lang/dafny/releases),
so these instructions mostly apply to people interested in looking at Dafny's sources or who want to use the latest features from the master branch.

0. Dependencies:
  a. [Install .NET](https://dotnet.microsoft.com/download)
  b. Install python3 (including pip3)

1. Create an empty base directory

       mkdir BASE-DIRECTORY
       cd BASE-DIRECTORY

2. Download and build Dafny:

       cd BASE-DIRECTORY
       git clone https://github.com/dafny-lang/dafny.git --recurse-submodules
       dotnet build dafny/Source/Dafny.sln
       cd dafny
       pip install pre-commit
       pre-commit install
       ## If java is installed
       make runtime

3. Download and unpack Z3 (Dafny looks for `z3` in Binaries/z3/bin/) version 4.8.5 (note, this is not the latest version of Z3). You can use

       make -C BASE_DIRECTORY/dafny z3-ubuntu

or

       cd BASE-DIRECTORY
       wget https://github.com/Z3Prover/z3/releases/download/Z3-4.8.5/z3-4.8.5-x64-ubuntu-16.04.zip
       unzip z3-4.8.5-x64-ubuntu-16.04.zip
       mv z3-4.8.5-x64-ubuntu-16.04 dafny/Binaries/z3

4. Run Dafny using the `dafny` shell script in the Binaries directory:
       BASE_DIRECTORY/dafny/Binaries/dafny

5. In VSCode, open any `.dfy` file, and when asked if you want to install the Dafny extension, click "install". This will install both the latest release of Dafny (which you decided not to use), but also the editor extension (which you want to use with your locally compiled Dafny version). To make sure the editor extension uses your locally compiled Dafny version, open the Settings page, search for "dafny base path", and set it to `BASE-DIRECTORY/dafny/Binaries`.

6. (Optional -- for testing) The Dafny test infrastructure uses a python tool 'lit'. Install it as follows:
   * run `pip install lit` and `pip install OutputCheck` or, if using python3, `pip3 install lit` and `pip3 install OutputCheck`
   * To execute the tests: `cd BASE_DIRECTORY/dafny/Test; lit .`
The tests take a while, depending on your machine, but emit progress output.

Building on Mac OS X
====================

You can use [Homebrew](https://brew.sh) to install Dafny:

       brew install dafny

Tested on Mac OS X 10.12.6 (Sierra).  Note that we now have
[official releases for Mac OS X](https://github.com/dafny-lang/dafny/releases),
so these instructions mostly apply to people interested in looking at
Dafny's sources or who want to use the latest features from the master branch.
You can use the script

   `https://github.com/dafny-lang/dafny/blob/master/setup-mac`

or follow these instructions manually:

0. Dependencies:
  a. [Install .NET](https://dotnet.microsoft.com/download)
  b. Install python (use `brew install python3`, or see https://www.python.org/downloads/)
  c. Install pip (above `brew` command will install it, or see https://pip.readthedocs.io/en/stable/installing/)
  d. (Optional) Install java (possibly use `brew cask install java` and then `java -version`)
  e. (Optional) Install go:  `brew install golang`
  f. (Optional) Install Javascript: `brew install node` and `npm install bignumber`

1. Create an empty base directory

       mkdir BASE-DIRECTORY
       cd BASE-DIRECTORY

2. Download and build Dafny:

       cd BASE-DIRECTORY
       git clone https://github.com/dafny-lang/dafny.git --recurse-submodules
       dotnet build dafny/Source/Dafny.sln
       cd dafny
       brew install pre-commit
       pre-commit install
       ## If java is installed:
       make runtime

3. Download and unpack Z3 (Dafny looks for `z3` in Binaries/z3/bin/) version 4.8.5 (note, this is not the latest version of Z3). You can use

       make -C BASE_DIRECTORY/dafny z3-mac

or

       cd BASE-DIRECTORY
       wget https://github.com/Z3Prover/z3/releases/download/Z3-4.8.5/z3-4.8.5-x64-osx-10.14.2.zip
       unzip z3-4.8.5-x64-osx-10.14.2.zip
       mv z3-4.8.5-x64-osx-10.14.2 dafny/Binaries/z3

4. Run Dafny using the `dafny` shell script in the Binaries directory:
       BASE_DIRECTORY/dafny/Binaries/dafny

5. (Optional) An IDE is available for dafny as an extension to VSCode.
VSCode itself is available from `https://code.visualstudio.com/download`.
In VSCode, open any `.dfy` file, and when asked if you want to install the Dafny extension, click "install". This will install both the latest release of Dafny (which you decided not to use), but also the editor extension (which you want to use with your locally compiled Dafny version). To make sure the editor extension uses your locally compiled Dafny version, open the Settings page, search for "dafny base path", and set it to `BASE-DIRECTORY/dafny/Binaries`.

6. (Optional -- for testing) The Dafny test infrastructure requires java, go, and javascript installed (cf. Dependencies above) and uses a python tool 'lit'. Install it as follows:
   * run `pip install lit` and `pip install OutputCheck` or, if using python3, `pip3 install lit` and `pip3 install OutputCheck`
   * To run the tests: `cd BASE_DIRECTORY/dafny; lit Test`. The tests take a while, depending on your machine, but emit progress output.

7. (Optional -- building the reference manual pdf) --- currently only on Linux and MacOS.
   * Dependencies:
        brew install basictex
        brew install pandoc
   * Build
	make -C BASE-DIRECTORY refman
   * The reference manual html does not require building. It is at
	https://dafny-lang.github.io/dafny/DafnyRef/DafnyRef
   * After building, the reference manual pdf is at
        BASE-DIRECTORY/docs/DafnyRef/DafnyRef.pdf
   * The committed version, pointed to by external links, is at
        BASE-DIRECTORY/docs/DafnyRef/out/DafnyRef.pdf
