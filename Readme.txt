If you have not already installed the FRC for eclipse plugins, do so following the instructions from the link here:
https://wpilib.screenstepslive.com/s/currentCS/m/java/l/599681-installing-eclipse-c-java

If you do not have the 2018 FRC update Suite, either 
-download it from (Windows only):
https://wpilib.screenstepslive.com/s/currentCS/m/java/l/599671-installing-the-frc-update-suite-all-languages

-or add the directory "<user home>/wpilib/user/lib" 
where on Windows, <user.home> will be C:\Users\<your name>. 
On Linux, it will be /home/<your user>. On Mac, it will be /Users/<your user>

Follow the instructions here to add Pathfinder to your project:
https://github.com/JacisNonsense/Pathfinder/wiki/Pathfinder-for-FRC---Java
The project used the "Pathfinder-Java.jar" from Pathfinder 1.5, released on May 18, 2016

Then in eclipse, in the project explorer right click on the project
Click on properties.
In the left-side pane, click on java build path.
In the main window, click on the libraries tab.
Click "Add External JARs..."
Navigate to "<user home>/wpilib/user/lib"
And choose Pathfinder-Java.jar
Click ok
Click apply
Click ok