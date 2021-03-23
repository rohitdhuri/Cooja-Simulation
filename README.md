Author- Rohit Mahendra Dhuri

# Academic honesty statement
“I have done this assignment completely on my own.I have not copied it, nor have I given my solution to anyone else.I understand that if I am involved in plagiarism or cheating I will have to sign an official form that I have cheated and that this form will be stored in my official university record. I also understand that I will receive a grade of 0 for the involved assignment for my first offense and that I will receive a grade of “F” for the coursefor any additional offense.”

## How to compile
- Extract contents of the zip to tinyos-main/apps/ directory.
- Open terminal in the extracted folder.
- Run command - make telsob

## How to run/use simulator
- Navigate to cooja fodler.
- Open terminal in the folder and run command - ant run
- Create a new simualtion
- Create two new skymotes with the SensorRadio compiled telosb .exe file.
- Place both motes in range of each other and start simulation to get reading in the mote output.

## Program Description
- Mote 1 measures the temperature, light and humidity on intervals of one, two and four seconds respectively.
- Transmits the packets with this data to Mote 2 and Mote 2 prints received data to the port.  

## Date: 10/04/2020
