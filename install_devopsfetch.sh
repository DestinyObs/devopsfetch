LOG_DIR="/mnt/c/Users/USER/devopsfetch/logs"
SERVICE_FILE="/etc/systemd/system/devopsfetch.service"
SCRIPT_PATH="/mnt/c/Users/USER/devopsfetch/devopsfetch.sh"

echo "Creating log directory..."
sudo mkdir -p "$LOG_DIR"

echo "Checking dependencies..."
for cmd in awk grep touch mkdir ss docker nginx last dmesg; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd is not installed. Installing..."
        sudo apt-get install -y $cmd
    fi
done

# Create a systemd service file
echo "Creating systemd service file..."
sudo bash -c "cat > $SERVICE_FILE <<EOF
[Unit]
Description=DevOps Fetch Service
After=network.target

[Service]
ExecStartPre=/bin/sleep 10
ExecStart=$SCRIPT_PATH
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

echo "Installation and setup complete."
