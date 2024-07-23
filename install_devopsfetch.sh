#!/bin/bash

# Define the log directory and service file paths
LOG_DIR="$HOME/devopsfetch/logs"
SERVICE_FILE="/etc/systemd/system/devopsfetch.service"

# Create the log directory if it doesn't exist
echo "Creating log directory..."
mkdir -p "$LOG_DIR"

# Check and install dependencies (example)
echo "Checking dependencies..."
for cmd in awk grep touch mkdir; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd is not installed. Installing..."
        sudo apt-get install -y $cmd
    fi
done

# Create a systemd service file
echo "Creating systemd service file..."
sudo bash -c "cat > $SERVICE_FILE <<EOF
[Unit]
Description=DevOpsFetch Service
After=network.target

[Service]
ExecStart=$HOME/devopsfetch/devopsfetch.sh
Restart=on-failure
User=$(whoami)

[Install]
WantedBy=multi-user.target
EOF"

# Reload systemd to recognize the new service
echo "Reloading systemd..."
sudo systemctl daemon-reload

# Enable and start the service
echo "Enabling and starting the devopsfetch service..."
sudo systemctl enable devopsfetch
sudo systemctl start devopsfetch

echo "Installation and setup complete."
