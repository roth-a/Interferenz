# Use

sudo apt install freeglut3-dev  

Just start the program (it is the file named: Interferenz or Interferenz.exe).
If you want help then just press F1, and you will find help texts to different parts of the program.


# Contact

You can just write me an e-mail to roth-a@gmx.de  


# Compilation

## Dependencies 


Synapse:  http://www.ararat.cz/synapse
  When you're in the Interferenz directory do:
  svn checkout https://svn.code.sf.net/p/synalist/code/trunk synapse

Expandpanels:  https://github.com/roth-a/expandpanels  
  When you're in the Interferenz directory do:
  git clone https://github.com/roth-a/expandpanels.git
  
  


Lazarus 

sudo apt install freeglut3-dev  



This you ONLY need to do if you have a !!!different!!! OS than: Windows (32 bit or 64bit), Linux (32 bit), Linux (64 bit).
If you have one of these named operating systems, I have done that work for you and you can just download and excecute the binary.
For Ubuntu 32bit and Ubuntu 64bit I have created .deb packages, so the program will integrate into the menu and you can deinstall it in your package manager.
All this you can download at:
http://www.alexanderroth.eu/meine_programme.htm#Interferenz

If you have a Windows with 64bit you can also download the Windows 32bit version.

Ok now for those, who can't or don't want to use a binary:

###### Install FPC and Lazarus ###########
This is developped with Lazarus.
 ### Windows ###
	You can download the daily snapshot from here:
		http://snapshots.lazarus.shikami.org/lazarus/
	or the older but stable version from here:
		http://sourceforge.net/project/showfiles.php?group_id=89339

 ### Linux ###
	(testet on Ubuntu, but it should work in other distributions too): 
	- You can install all the dependences (most of them are the Free Pascal Compiler) with this command:
	- console command:
sudo apt-get install fp-compiler fp-units-base fp-units-fcl fp-units-gtk fp-units-rtl fpc-abi-2.2 libc6 libgdk-pixbuf-dev libgdk-pixbuf2 libglib1.2ldbl libgtk1.2 libgtk1.2-dev libx11-6 libxext6 libxi6 fp-units-db fp-units-gfx fp-units-gnome1 fp-units-misc fp-units-net fpc-source fp-utils libglib1.2-dev libgdk-pixbuf2 libgdk-pixbuf-dev libgtk1.2 libgtk1.2-common libgtk1.2-dev libglut3-dev subversion

	   Now install the latest Lazarus version with the following commands:
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

	

 ### Other way for Linux ###
	Instead of usion the version out of the svn you can just download different versions:
	You can download the daily snapshot from here:
		http://snapshots.lazarus.shikami.org/lazarus/
	or the older but stable version from here:
		http://sourceforge.net/project/showfiles.php?group_id=89339
	
	Follow the instruction above and leave the subversion (svn) command out

