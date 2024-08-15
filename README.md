# usb_device_namer

This script is designed to address the frustrating naming conventions of USB devices on Ubuntu. `/dev/ttyACM0` is simply not a useful name, and the fact that the same hardware can change its name every time you restart your computer is beyond annoying.

When you want to interface with these devices programmatically, it can be tedious to set up the environment due to the requirement of either hard-coded names or bloated code looking for hardware identifiers. This script allows you to take an unhelpful path like `/dev/ttystupidpath` and turn it into something genuinely readable like `/dev/front_camera`. The best part is that once you name the device, the link will persist on the computer no matter which port it is mounted on.

## Getting Started

### Clone the Repository

First, you need to clone the repository:

```
git clone https://github.com/Victor-Boyd/usb_device_namer.git
```

### Make the Script Executable

Next, make the script executable by running this command in the same directory as the file:

```
chmod +x usb_device_namer.sh
```

### Find the Device Path

To get started, first figure out the name of the device you want to change:

```
ls /dev/tty*
```

This will list many things, but chances are your device falls under `/dev/ttyA*` or `/dev/ttyUSB*`, so you can try those as well.

If you don’t know the device path just by looking at this, try unplugging the device and running the above command again to see what disappears from the list.

### Run the Program

Once you have pinpointed the device path, you can run the program:

```
sudo ./usb_device_namer.sh path=<whatever_your_path_was> name=<new_much_better_name>
```

### Expected Output

If everything goes right, you will get the output:

```
udev rule created successfully.
The device at <original_path> will now be accessible via <new_far_better_path> regardless of the port it's connected to.
Rule file created: /etc/udev/rules.d/99-<new_name>.rules
```

### Validate the Link

To validate the link, run this command:

```
ls <new_path>
```

Now you have your devices linked, so you never have to worry about any unnecessary setup again!
