# Use

#### Linux
Dependency
```
sudo apt install freeglut3-dev  
```
and run the binary interferenz

#### Windows 
Make sure the Interferenz.exe and make sure the **glut32.dll** is in the same directory


## Contact

You can just write me an e-mail to roth-a@gmx.de  

![](/media/alexander/hdd/Daten/Programmieren/meine/Interferenz/screenshot.jpg)


# Development  Info

### Components for Lazarus

Synapse:  http://www.ararat.cz/synapse
  When you're in the Interferenz directory do:
  svn checkout https://svn.code.sf.net/p/synalist/code/trunk synapse

Expandpanels:   http://wiki.lazarus.freepascal.org/TMyRollOut_and_ExpandPanel  
  Download and install the component into Lazarus
  git clone https://github.com/roth-a/expandpanels.git

ColoredBox:  https://github.com/roth-a/ColoredBox  Download and install the component into Lazarus
  git clone https://github.com/roth-a/ColoredBox.git

SimpleWebViewer: https://github.com/roth-a/SimpleWebViewer Download and install the component into Lazarus
	  git clone https://github.com/roth-a/SimpleWebViewer.git
      
GroupHeader:  https://github.com/roth-a/GroupHeader    Download and install the component into Lazarus
	  git clone https://github.com/roth-a/GroupHeader.git

freeglut3-dev  :  sudo apt install freeglut3-dev



### Install FPC and Lazarus 

#### Windows 
	You can download the daily snapshot from here:
		http://snapshots.lazarus.shikami.org/lazarus/
	or the older but stable version from here:
		http://sourceforge.net/project/showfiles.php?group_id=89339

#### Linux 

##### fpc

Lazarus  > 1.6

fpc

```
sudo apt-get install fp-compiler fp-units-base fp-units-fcl fp-units-gtk fp-units-rtl fpc-abi-2.2 libc6 libgdk-pixbuf-dev libgdk-pixbuf2 libglib1.2ldbl libgtk1.2 libgtk1.2-dev libx11-6 libxext6 libxi6 fp-units-db fp-units-gfx fp-units-gnome1 fp-units-misc fp-units-net fpc-source fp-utils libglib1.2-dev libgdk-pixbuf2 libgdk-pixbuf-dev libgtk1.2 libgtk1.2-common libgtk1.2-dev libglut3-dev
```


##### Lazarus

install the latest Lazarus version with the following commands:
	- Create the directory ~/home/Programs/Lazarus
	- console command: cd ~/home/Programs/Lazarus
	- console command: svn co http://svn.freepascal.org/svn/lazarus/trunk ./
	- console command: make all
	- Now you can start lazarus
	- you have to install some of my own components (in Lazarus it is called Packages):
	- go to all of this links and download the components (download Button is in the right bottom corner):
http://www.lazarusforum.de/downloads.php?view=detail&df_id=17
http://www.lazarusforum.de/downloads.php?view=detail&df_id=21
http://www.lazarusforum.de/downloads.php?view=detail&df_id=20
http://www.lazarusforum.de/downloads.php?view=detail&df_id=18
	- extract the downloaded files
	- Now you have to install the Packages in Lazarus with these steps:
	- in the Lazarus menu --> Open Package File --> select the .lpk file and open it
	- now a window opens. You should hit the install button and then click NO. (This will mark this package for installation but it doesn't recompile Lazarus)
	- Repeat the last step with all the 4 packages.
	- Now go to Tools --> Build Lazarus
	- When Lazarus has restart you can open my Project Interferenz and compile it by pressing F9

If you want to have a nicer theme, and not the old grey Windows89 like one, you can compile Lazarus with the new gtk2 widgetset:
	- go to Tools --> Build Lazarus Settings --> Select Build IDE with Packages and select gtk2 on the right side
	- Hit ok. After the restart you can recompile Interferenz and there you go. It should be everything looking nice.

	