Download : https://github.com/pallebone/ConkyVisionReborn/raw/refs/heads/main/ConkyVisionReborn.tar.gz

# ConkyVisionReborn
Fixed Conky Vision for API 3.0 of openweathermap

This is a fix of Conky Vision Clock and Weather that should look like this (current temperature istop left value and subsequent days are high and lows of each day):

![alt text](https://github.com/pallebone/ConkyVisionReborn/blob/main/Screenshot%20From%202024-10-24%2011-31-58.png?raw=true)

The original had several issues such as using API call 2.5 (now depreciated and cannot be used) and rounding errors using awk (-3.9 would be rounded to -3 instead of -4 for negative temperatures). This version also splits the clock which updates every 3 seconds and the weather which updates every 101 seconds as you are only allowed 1000 calls per day on a free account with openweathermap. There are still issues in the code that are not fixed such as requiring the files be placed in ~/.conky/ as opposed to any arbitrary path but I havent fixed these. If you want to clean up the code you can, but this functions and thats all I was going for, and it took long enought to fix anyway.

USAGE:
1) Create an openweapthermap account and generate an API key (you will need an API key later)
2) Set Calls per day on the account max to be 990 so you do not get billed if you use more than 1000 calls in a day (under billing plans).
3) Download the zip and extract it to /home/username/.conky (~/.conky)
4) there should be these files: /images folder with the images, /json folder with the captured weather data, clock.conkyrc, clock_rings.lua, ConkySymbols.ttf, forecast.conky, PoiretOne-Regular.ttf, transparent-image.lua.
5) The clock and weather data part of conky is 2 seperate conky files so you can use your own clock if you want (eg: digital) or not at all.
6) Edit the forecast.conky file. At a minimum you need to put your API key in template6 and your cities latitude and longitude into template7 and template5 which you can find on openweathermap.
7) To run conky you can create a script that runs on login. Here is an example for Gnome:

```
Script example:
#!/bin/sh
export DISPLAY=:0
killall conky
sleep 15
cd /home/aragorn/.conky
conky -d -c /home/aragorn/.conky/clock.conkyrc
conky -d -c /home/aragorn/.conky/forecast.conky'
```

Save this as conkyrun.sh and +x

Gnome autostart example:
under ~/.config/autostart create a file eg: conky2.desktop - example autostart file:

```
[Desktop Entry]
Type=Application
Exec=sh -c "/Scripts/conkyrun.sh"
Hidden=false
X-MATE-Autostart-enabled=true
X-GNOME-Autostart-enabled=true
Terminal=false
Name[en_CA]=conky2
Name=conky2
Comment=A comment
X-MATE-Autostart-Delay=4
X-GNOME-Autostart-Delay=4
```

This would cause the clock and weather to run on login. Note, they take about a minute to sort out all the icons and display them so wait 60 seconds.

To just run the conky from a terminal you can run a command like this:
```cd ~/.conky/ && conky -d -c /home/aragorn/.conky/clock.conkyrc && conky -d -c /home/aragorn/.conky/forecast.conky```
then wait 60 seconds for it to all load up.
