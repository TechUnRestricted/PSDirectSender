# PSDirectSender
  Native **macOS app** for sending **.pkg games** to **PS4** console using **Remote Package Installer**.  
  Written in Swift, Objective-C and C.  

## Current features
  * Sending local .pkg files
  * Drag'n'drop support
  * Automatic .pkg title detection 
  * Creating aliases for files for correct sending .pkg containing spaces in the name.
  * Advanced logging system
  * Automatic appropriate data generation for the server (IP, Port)
  * English / Russian language support

<img width="998" alt="image" src="https://user-images.githubusercontent.com/83237609/166961465-36cb0ac6-00b1-405e-b28a-da6b4b8b6b9e.png">

<details>
  <summary><ins>-> more screenshots <-</ins></summary>
<img width="998" alt="image" src="https://user-images.githubusercontent.com/83237609/166961339-b21e1760-7d7c-4874-a4b9-4eb43db63fb1.png">
<img width="998" alt="image" src="https://user-images.githubusercontent.com/83237609/166960997-26f97f01-cb63-40a6-ae71-a16796d588e3.png">
</details>

### To be implemented later
  * Resume, pause, stop functionality
  * Viewing progress
  
## System Requirements
  * macOS 11.0+
  * Apple Silicon / Intel / AMD CPU
  * Wired or wireless connection to the same network as PS4
  * Local PS4-compatible .pkg files

## Usage
  <ol>
    <li>Open <b>PSDirectSender</b></li>
    <li>Go to the Configuration section</li>
    <li>Fill the Console Configuration. (Server configuration should be generated automatically)</li>
    <li>Press "Apply settings and Restart Server"</li>
    <li>Open Remote Package Installer on PS4</li>
    <li>Go to the Queue section</li>
    <li>Choose .pkg files from the picker or use the drag'n'drop feature</li>
    <li>Press "Send"</li>
  </ol>  
    
  You can follow the progress from "Notifications" on your PS4
