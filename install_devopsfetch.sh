#!/bin/bash

# Define variables
LOG_DIR="/mnt/c/Users/USER/devopsfetch/logs"
SERVICE_FILE="/etc/systemd/system/devopsfetch.service"
SCRIPT_PATH="/mnt/c/Users/USER/devopsfetch/devopsfetch.sh"

# Update package list and install dependencies
echo "Updating package list and installing dependencies..."
sudo apt update
sudo apt install -y nginx docker.io containerd systemd net-tools

# Check additional dependencies
echo "Checking additional dependencies..."
for cmd in awk grep touch mkdir ss docker nginx last dmesg; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd is not installed. Installing..."
        sudo apt-get install -y $cmd
    fi
done

# Copy the devopsfetch script to /usr/local/bin
echo "Copying devopsfetch script to /usr/local/bin..."
sudo cp $SCRIPT_PATH /usr/local/bin/devopsfetch
sudo chmod +x /usr/local/bin/devopsfetch

# Create log directory
echo "Creating log directory..."
sudo mkdir -p "$LOG_DIR"

# Create systemd service file
echo "Creating systemd service file..."
sudo bash -c "cat > $SERVICE_FILE <<EOF
[Unit]
Description=DevOps Fetch Service
After=network.target

[Service]
ExecStartPre=/bin/sleep 10
ExecStart=/usr/local/bin/devopsfetch
User=root
Restart=always
RestartSec=60
StandardOutput=append:$LOG_DIR/devopsfetch.log
StandardError=append:$LOG_DIR/devopsfetch_error.log

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

# Set up logrotate for devopsfetch logs
echo "Setting up logrotate for devopsfetch logs..."
sudo bash -c "cat > /etc/logrotate.d/devopsfetch <<EOF
$LOG_DIR/*.log {
    su root root
    daily
    rotate 7
    compress
    missingok
    notifempty
    create 0640 root adm
    sharedscripts
    postrotate
        systemctl restart devopsfetch
    endscript
}
EOF"
echo "Installation complete. DevOps Fetch is now running as a systemd service."
