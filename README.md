# Instructions for Use

1. [Get the nPoint LC.400 recognizable as a Virtual COM Port (VCP)](#vcp) on your computer. Do not proceed until this is complete.
<a name="step2"</a>
2.  Clone the git repo into your MATLAB project `$ git clone https://github.com/cnanders/matlab-npoint.git`
3. Add the repo to the MATLAB path `addpath('matlab-npoint');`
4. In MATLAB, there are two ways to access classes within a package
    1. Through the full qualified namespace, i.e., `lc400 = npoint.lc400.LC400();`
    2. Alternatively, you can import a package or class, e.g., `import npoint.lc400.LC400` within the scope of a script or function and access the class directly, e.g., `LC400`.  With this approach, you don’t have to use the full qualified name within the scope of the import.
5. When instantiating the `npoint.lc400.LC400` instance, use the [varargin syntax](https://www.mathworks.com/help/matlab/ref/varargin.html) to pass a property `cPort` with the VCP value you obtained in step 1, e.g., `lc400 = npoint.lc400.LC400('cPort', '/dev/tty.usbserial-7440002A');`

<a name="vcp"></a>

# Making the nPoint LC.400 Recognizable as a Virtual COM Port

## Communication Protocol

You will use the serial() communication protocol in MATLAB to talk to the FTDI chip in the LC400.  The FTDI chip is USB but FTDI provides a USB -> Virtual COM Port (VCP) driver available for macOS and Windows. 

## macOS Users

macOS >= 10.9 (Mavericks) ships with included built-in partial support for some FTDI devices in VCP mode.  macOS >= 10.11 (El Capitan) have really good support.  Before you [download the FTDI driver](http://www.ftdichip.com/Drivers/VCP.htm) and install it, see if your OS already recognizes the LC400.

### Checking for LC.400 in Terminal

Connect a USB cable between your computer and the LC400 and power on the LC400. In terminal, you can list all of the available COM ports by name by running:

`ls  -l /dev/{tty,cu}.*`

This command searches the /dev directory for all files that begin with “tty” or “cu”, which is how VCP devices are named.  

The output will look something like this.  The **bold** items are the ones corresponding to the LC.400

* /dev/cu.Bluetooth-Incoming-Port
* /dev/cu.BoseQC35-SPPDev
* /dev/cu.BoseQC35-SPPDev-1
* **/dev/cu.usbserial-7440002A**
* **/dev/cu.usbserial-7440002B**
* /dev/tty.Bluetooth-Incoming-Port
* /dev/tty.BoseQC35-SPPDev
* /dev/tty.BoseQC35-SPPDev-1
* **/dev/tty.usbserial-7440002A**
* **/dev/tty.usbserial-7440002B**

If you see them, proceed.  If not, [download the FTDI driver](http://www.ftdichip.com/Drivers/VCP.htm) and try again.  If you still have problems, consult the [FTDI website](http://www.ftdichip.com/Drivers/VCP.htm).

The “dev/tty.usbserial-xxxxxxxA” is the string you pass to the {serial} in MATLAB when creating it.  No go back go [step 2 of the instructions](#step2)

## Windows Users

I’m on macOS and didn’t go through the Windows process.  But it is similar.  Please consult the [FTDI website](http://www.ftdichip.com/Drivers/VCP.htm).



# Hungarian Notation

This repo uses [Hungarian notation](https://github.com/cnanders/matlab-hungarian) for variable names.  

# Recommended Project Structure


* project
  * libs
    * lib-a
    * lib-b
  * pkgs
    * matlab-npoint
      * +noint
	* other-a
      * +other-a
	* other-b
      * +other-b
  * classes
    * ClassA.m
    * ClassB.m
  * tests
  	* TestClassA.m
  	* TestClassB.m
  * README.md (list lib dependencies)
  * .git
  * .gitignore (should ignore /libs and /pkgs)