# Installation

1. [Make the nPoint LC.400 recognizable as a Virtual COM Port (VCP)](#vcp) on your computer. Do not proceed until this is complete.

2. This repo and its dependencies are namespaced packages.  See [Working With Packages in MATLAB](https://github.com/cnanders/matlab-package-notes) for more information.
    1. Clone this repo into your MATLAB project, preferably in a “vendor” directory.  See [Recommended Project Structure](#project-structure)
    2. Clone the repos of all [dependencies](#dependencies) into the “vendor” folder of your MATLAB project. 
3. Add the namespaced packages to the MATLAB path, e.g., 

```matlab
addpath('vendor/github/cnanders/matlab-hex/src');
addpath('vendor/github/cnanders/matlab-ieee/src');
addpath('vendor/github/cnanders/matlab-npoint-lc400/src');
```
5. When instantiating the `npoint.lc400.LC400` instance, use the [varargin syntax](https://www.mathworks.com/help/matlab/ref/varargin.html) to pass a property `cPort` with the VCP value you obtained in step 1, e.g., `lc400 = npoint.lc400.LC400('cPort', '/dev/tty.usbserial-7440002A');`

<a name="vcp"></a>

# Making the nPoint LC.400 Recognizable as a Virtual COM Port

## Communication Protocol

You will use the serial() communication protocol in MATLAB to talk to the FTDI chip in the LC400.  The FTDI chip is USB but FTDI provides a USB -> Virtual COM Port (VCP) driver available for macOS and Windows. 

## macOS Users

macOS >= 10.9 (Mavericks) ships with included built-in partial support for some FTDI devices in VCP mode.  macOS >= 10.11 (El Capitan) has even better support.  Before you [download the FTDI driver](http://www.ftdichip.com/Drivers/VCP.htm) and install it, [check for the LC.400 in Terminal](#terminal) to see your OS already recognizes the LC400.

<a name="terminal"></a>
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

The “dev/tty.usbserial-xxxxxxxA” is the string you pass to the {serial} in MATLAB when creating it.  Now go back go [step 2 of the instructions](#step2)

## Windows Users

I did the install on Windows 7.  For other versions of Windows, Please consult the  [Installation Guides](http://www.ftdichip.com/Support/Documents/InstallGuides.htm) on the [FTDI website](http://www.ftdichip.com/Drivers/VCP.htm).  I found that the [Windows 7 Installation Guide](http://www.ftdichip.com/Support/Documents/AppNotes/AN_119_FTDI_Drivers_Installation_Guide_for_Windows7.pdf) didn't get me all the way to the VCP.  Adam Frost (nPoint) walked me through the last step.  Do this instead:

1. [Download the VCP driver](http://www.ftdichip.com/Drivers/VCP.htm) from the FTDI website and expand the .zip file
2. Control Panel -> Hardware and Sound -> under “devices and printers" click "Device Manager"
3. Under "Other Devices", there will be two LC400s listed (apparently the FDTI chip has two USB boards, we only use the first one)
4. Right click the first one and select "Update Driver"
5. Choose the driver at the location of your download in step 1.
6. Now back in Device manager under "Universal Serial Bus Controllers" there will be something called "USB Serial Converter A".  
7. Right click "USB Serial Converter A" -> Properties -> Advanced -> on the "Advanced" tab, click "Load VCP" and click "OK".
8. Unplug the USB cable from the machine.  Plug the USB cable back in.  Wait a minute or two.  Refresh the Device Manager.  Now under "Ports" you will see "USB Serial Port (COM3)"
9. You are done.

# TCP/IP Notes

1. Network control uses the telnet port 23. Devices with this port open are not permitted on the LBNL WAN. They are also hammered by the network scans and usually lock up the device. (we encountered similar problems with the Galil controllers). So, you need to put the device on a private subnet. **You will most likely need a computer with dual Ethernet**.

2. The nPoint only uses DHCP for address resolution. You can't assign a permanent IP address via NVRAM. Jeff needs to set up a DHCP server on your control PC and assign a fixed IP to the nPoint on the private subnet.

If you follow the above guidelines, things are pretty straightforward thereafter. We did this with the LC.401 controller on the IntelAis project and it worked without problems. Remember that you have to open a socket connection to port 23 (telnet) when you talk to the device.

# Hungarian Notation

This repo uses [MATLAB Hungarian notation](https://github.com/cnanders/matlab-hungarian) for variable names.  

<a name="dependencies"></a>
# Dependencies

- [github/cnanders/matlab-hex](https://github.com/cnanders/matlab-hex.git)
- [github/cnanders/matlab-ieee](https://github.com/cnanders/matlab-ieee.git)

<a name="project-structure"></a>
# Recommended Project Structure


- project
	- vendor
		- github
			- cnanders
				- matlab-npoint-lc400 **(this repo)**
				- matlab-hex **(dependency)**
				- matlab-ieee **(dependency)**
- file_a.m
- file_b.m