# MaracaSpace

<hr>

<img align="left" src="https://github.com/andre3pazo/HW3-CMLS/assets/89461273/15447dbe-e8c2-4650-9227-208e279d383d" alt="The GUI" width="600" height="whatever">

This is the third homework for the Computer Music Languages and Systems
course. The final goal of this homework id to develop a complete computer music system: we
decide to implement a system composed by a computer program and an Arduino UNO board,
plus a couple of sensors connected to the Arduino board.

<br />
<br />
<br />
<br />

<hr>

<br />

<p align="center">
  <img src="https://github.com/andre3pazo/HW3-CMLS/assets/89461273/dbf14873-58d7-4990-8f01-777fd3566330" alt="CMS diagram" width = 681 height="whatever">
</p>
<br />
<img align="right" src="https://github.com/andre3pazo/HW3-CMLS/assets/89461273/86f871e1-edb6-458a-88bf-b1c4b8c0adee" alt="Schematics" width="400" height="whatever">

This computer music system exploits both hardware and software elements in order to simulate the
experience of playing a maraca and simultaneously hearing its sound coming from different positions
on a theater stage, simulating a spacial movement.
The user may modify some features of the sound and the position of the maraca on the stage by
interacting both with the couple of physical sensors and the Graphical User Interface hosted on the
PC.
The general idea of the entire system is as follows: Arduino board is connected to a PC, and
serial messages are transmitted from the Arduino sketch loaded on our Arduino UNO board to the
Processing sketch for GUI interaction design. On the other hand, the Processing sketch sends OSC
messages to our SuperCollider program, which generates sound based on the received messages. The
sound is then played through the computer’s speakers.
In summary, the breakdown of the roles of each component:
* Arduino: The Arduino board is connected to the PC. The serial messages are sent to Processing
for GUI interaction;
* Processing: It receives serial messages from the Arduino board and creates a graphical user
interface (GUI) for interaction and visualization;
* SuperCollider: It receives OSC messages from the Arduino board and generates sound based on
the received messages.
* Computer speakers: They play the sound generated from SuperCollider.

