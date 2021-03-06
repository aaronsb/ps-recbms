![REC-BMS](https://raw.githubusercontent.com/aaronsb/REC-BMSManager/main/images/rec-logo.png)
# REC-BMSManager
# Console management tools for REC-BMS 1Q battery management systems.
Powershell based management for REC-BMS battery management modules. Built and designed by [Rec-BMS](http://rec-bms.com/), these modules are chainable as a parent-> multi child BMS system in harsh conditions. They are very robust.

![REC-BMS](https://raw.githubusercontent.com/aaronsb/REC-BMSManager/main/images/bmsmodule.png)

# What Is This?
* Check out the screenshots down below.👇👇
* Offer a "lightweight" implementation of getting and setting data from REC-BMS that isn't reliant on a big Windows installer.
* Offer more insight into the messaging component of on the wire data to and from the BMS microcontroller.
* Build a general framework for parsing and understanding the intracacies of the instructionset.

## Other Considerations
* Internally, these modules use the  ```System.IO.Ports.SerialPort``` object to talk on the wire. I seem to get occasional hangups and resets, so there is some testing and lazy starts to events to soften the fragility of that state.
* This toolset functions properly in both Windows and Linux environments. It was developed in Powershell Core

# How To Install
Install from the PSGallery

```Install-Module -Name REC-BMSManager -AllowPrerelease```

Optionally, you can clone from the git repo into your modules directory. If you plan on instancing this as a systemd daemon on Linux, you need to import the module to the system module location, typically ```/opt/microsoft/powershell/7/Modules/``` directory, if for example you were using Powershell 7.x.x

## Example Installation Instructions

1. Copy and paste this into a Powershell console, which will clone into your user profile modules path. ```git clone https://github.com/aaronsb/REC-BMSManager.git (Join-Path -Path $env:PSModulePath.Split(":")[0] -ChildPath /REC-BMSManager)```

2. Code security and signing will need to be adjusted. Since none of this code is signed, [you'll need to manage your execution policy to allow it to run](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7). Unrestricted usually works - if you are uncomfortable with that, you should review the code and then sign all of the modules.

3. You'll need to import the module into your Powershell session. Enter the command ```Import-Module REC-BMSManager``` to load this module into your session. If you'd like that to be persistent, then edit your profile with ```nano $profile``` or ```notepad $profile```, and add the Import-Module command to load every time.

# Advanced Installation
This service has the ability to be installed as a systemd daemon and (eventually) a Windows service. The requirements for using this as a systemd service is basically the following:
Make sure you can run the general commands as root. So like, "sudo -i" and then run. This means everything is in your user profile and auto loading the configuration directly.

(To be updated later...)
In a root session, you can use Install-BMSMQTTService to generate a configuration file for your MQTT broker and set it up as a service.
Caution: I haven't written the uninstaller yet, but basically it drops a service unit file into /etc/systemd/system/recbmsmqtt.service, a conf file into /etc/opt/recbms/mqtt.conf, and an executable script into /usr/bin/recbmsmqtt. Deregister the service and delete them, and it's gone again. :)


## Configuring your installation

You'll need to configure your serial port. If you use the cable that comes from REC, it's an rs-485 FTDI USB Serial device. Every time the module is loaded, the global environment variable ```$BMSInstructionSet``` is loaded. You can either set the configuration every time you want, or edit the _instructionset.json_ file in the module /Public resources directory.

For example, ```$BMSInstructionSet.Config.Client``` returns the parameters:

    
    ❯ $BMSInstructionSet.Config.Client

      PortName     : /dev/ttyUSB0
      BaudRate     : 38400
      Parity       : None
      DataBits     : 8
      StopBits     : One
      ReadTimeout  : 900
      WriteTimeout : 250
      DTREnable    : True
      ```
You can change the Port Name by setting the variable:

    ❯ $BMSInstructionSet.Config.Client.PortName = "COM6"
    
    ❯ $BMSInstructionSet.Config.Client.BaudRate = "56000"
    

# Using The Console Tools

## Getting data from the BMS
```Get-BMSParameter``` gets parameters from the BMS. You can add them as a list, or just issue a single command. Depending on the mood of your BMS (aka, it's busy and not dealing with interrupts), it might not reply and take a bit of time to return the data.

![Example](https://raw.githubusercontent.com/aaronsb/REC-BMSManager/main/images/get-example.gif)

# MQTT Helper Script

```Send-MQTT``` is something I'm working on to log BMS parameters long term. You'll need to supply credentials to it. The function also requires mosquitto_pub, which exists on Linux, but maybe not on Windows. Future improvements should make that more available on Windows. M2MQTT will probably be the answer to that.

![Example](https://raw.githubusercontent.com/aaronsb/REC-BMSManager/main/images/MQTT.gif)

# systemd service installer/uninstaller to ship values to MQTT broker

```Install-BMSMQTTService``` is a service used to install and configure a systemd based service poller that pushes the content to an MQTT broker.
You need to have installed the REC-BMSManager module in your system-wide powershell environment. For example:

cd /opt/microsoft/powershell/7/Modules
git clone https://github.com/aaronsb/REC-BMSManager.git

This is necessary due to the way systemd calls the service and requires the Powershell module to be available.

Here is a short example of installing the service.
![Example](https://raw.githubusercontent.com/aaronsb/REC-BMSManager/main/images/install-bmsmqttservice.gif)

Here is a short example of updating the service parameters. Make sure you restart the service for the changes to take effect.
![Example](https://raw.githubusercontent.com/aaronsb/REC-BMSManager/main/images/update-bmsmqttservice.gif)

Here is a short example of uninstalling the service.
![Example](https://raw.githubusercontent.com/aaronsb/REC-BMSManager/main/images/uninstall-bmsmqttservice.gif)


## Sending data to the BMS
```Set-BMSParameter``` is the command to set parameters that are setable. One value per instruction. All instructions are validated against library min and max values.

![Example](https://raw.githubusercontent.com/aaronsb/REC-BMSManager/main/images/set-example.gif)

## Listing Available Instructions
```Get-BMSInstructionList``` is a command reference based on the technical installation manual from REC. There are various arguments to filter different commands. The table has a brief explaination of what the instructions mean.

![Example](https://raw.githubusercontent.com/aaronsb/REC-BMSManager/main/images/instructionlist.gif)

## Diagnosing issues
Try using ```-Verbose``` on any of the commands to get a full trace of what happens during execution. This might help you in diagnosing issues with communication or configuration.

## Things Still To-Do!
The intention of this set of management functions is as follows:

- [x] Use byte format internally with messaging
- [x] Build functions as a module
- [x] Write a systemd service installer
- [x] Write a systemd service configurator
- [x] Write a systemd service uninstaller
- [ ] Write a windows service installer
- [ ] Write Pester tests to ensure things are working right on future releases
- [x] Figure out instructions to perform writes to module
- [ ] Write function get-help blocks for additional documentation.
- [x] Add an MQTT exporter
- [ ] Make a pscore docker environment so it just sorta works.


Current release notes:
* REC-BMS 1Q is based on an Amtel AVR32 90CAN32 microcontroller
* In order for me to get this to function in Linux, I requested REC-BMS to issue a special firmware that can communicate on 38400 BPS, because 56000 BPS (default) isn't a compatible BPS rate with FTDI USB Serial chipsets. If anyone knows how to make that rate work easily, please let me know!


Future plans:
* Since I use Home Assistant, I am planning on building a docker container that turns this module into a sensor platform. This way, it easily becomes integrated with long term metrics and telemetry.


![Getting BMS Parameters](https://raw.githubusercontent.com/aaronsb/REC-BMSManager/main/images/get-parameters.gif)

![Functions have extra verbosity!](https://raw.githubusercontent.com/aaronsb/REC-BMSManager/main/images/get-bmsparameters-verbose.gif)
