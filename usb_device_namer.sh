#!/bin/bash


# Check if the user is root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo to run it."
  exit 1
fi

# Parse the command-line arguments
for ARG in "$@"; do
  case $ARG in
    path=*)
      DEVICE_PATH="${ARG#*=}"
      shift
      ;;
    name=*)
      DEVICE_NAME="${ARG#*=}"
      shift
      ;;
    *)
      echo "Unknown argument: $ARG"
      exit 1
      ;;
  esac
done

# Check if both path and name arguments are provided
if [ -z "$DEVICE_PATH" ] || [ -z "$DEVICE_NAME" ]; then
  echo "Usage: sudo $0 path=/dev/ttyACM0 name=new_name"
  exit 1
fi

# Check if the specified device path exists
if [ ! -e "$DEVICE_PATH" ]; then
  echo "The specified device path does not exist: $DEVICE_PATH"
  exit 1
fi

# Get the attributes for the specified device
VENDOR_ID=$(udevadm info -a -n "$DEVICE_PATH" | grep 'ATTRS{idVendor}' | head -n 1 | awk -F'==' '{print $2}' | tr -d '"')
PRODUCT_ID=$(udevadm info -a -n "$DEVICE_PATH" | grep 'ATTRS{idProduct}' | head -n 1 | awk -F'==' '{print $2}' | tr -d '"')
SERIAL_ID=$(udevadm info -a -n "$DEVICE_PATH" | grep 'ATTRS{serial}' | head -n 1 | awk -F'==' '{print $2}' | tr -d '"')

# Check if all required attributes were found
if [ -z "$VENDOR_ID" ] || [ -z "$PRODUCT_ID" ] || [ -z "$SERIAL_ID" ]; then
  echo "Failed to retrieve device attributes for: $DEVICE_PATH"
  exit 1
fi

# Create the udev rule
UDEV_RULE="SUBSYSTEM==\"tty\", ATTRS{idVendor}==\"$VENDOR_ID\", ATTRS{idProduct}==\"$PRODUCT_ID\", ATTRS{serial}==\"$SERIAL_ID\", SYMLINK+=\"$DEVICE_NAME\", MODE=\"0666\""

# Write the udev rule to /etc/udev/rules.d/
RULE_FILE="/etc/udev/rules.d/99-$DEVICE_NAME.rules"
echo "$UDEV_RULE" > "$RULE_FILE"

# Reload the udev rules and trigger them
udevadm control --reload-rules
udevadm trigger

echo "udev rule created successfully."
echo "The device at $DEVICE_PATH will now be accessible via /dev/$DEVICE_NAME regardless of the port it's connected to."
echo "Rule file created: $RULE_FILE"

