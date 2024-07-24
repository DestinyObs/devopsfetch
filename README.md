Here is the corrected Markdown for your GitHub README file:

```markdown
# devopsfetch

`devopsfetch` is a Bash-based tool designed for monitoring and retrieving detailed server information. It collects data on system activities, ports, user logins, Nginx configurations, Docker images, and more, with robust logging and rotation features.

## Features

- **System Information Retrieval:**
  - Active ports and their services
  - User logins and activities
  - Nginx domain configurations
  - Docker images and container statuses

- **Log Management:**
  - Comprehensive logging with automatic rotation and compression

- **Time-Based Data Retrieval:**
  - Retrieve logs and system information based on time ranges

## Installation

Follow these steps to install and set up `devopsfetch`:

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/DestinyObs/devopsfetch.git
   ```

2. **Navigate to the Project Directory:**

   ```bash
   cd devopsfetch
   ```

3. **Run the Installation Script:**

   ```bash
   ./install_devopsfetch.sh
   ```

   The `install_devopsfetch.sh` script performs the following actions:

   - **Updates Package List and Installs Dependencies:** Ensures necessary packages and utilities are installed (`nginx`, `docker`, `containerd`, `systemd`, `net-tools`, and other essential commands like `awk`, `grep`, `touch`, `mkdir`, `ss`, `docker`, `nginx`, `last`, and `dmesg`).
   - **Copies the `devopsfetch` Script:** Moves the main script to `/usr/local/bin` and makes it executable.
   - **Creates Log Directory:** Sets up the directory for storing logs at `/mnt/c/Users/USER/devopsfetch/logs`.
   - **Creates a Systemd Service:** Configures `devopsfetch` to run as a systemd service, ensuring it starts on boot and restarts on failure.
   - **Sets Up Log Rotation:** Configures `logrotate` to manage log file sizes, rotation, and compression.

4. **Verify Installation:**

   Ensure the service is running correctly:

   ```bash
   sudo systemctl status devopsfetch
   ```

## Log Rotation Configuration

To manage log file sizes and ensure regular rotation, the installation script sets up `logrotate`. Here’s how it works:

1. **Logrotate Configuration:**

   The script creates a configuration file at `/etc/logrotate.d/devopsfetch`. This file contains:

   ```bash
   $LOG_DIR/*.log /logs/*.log {
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
   ```

   **Explanation:**
   - **`daily`**: Rotate logs daily.
   - **`rotate 7`**: Keep 7 rotated logs.
   - **`compress`**: Compress old logs.
   - **`missingok`**: Ignore missing log files.
   - **`notifempty`**: Do not rotate empty logs.
   - **`create 0640 root adm`**: Create new log files with specific permissions.
   - **`postrotate`**: Restart the `devopsfetch` service after rotation to ensure it continues logging properly.

2. **Manual Logrotate Application:**

   You can manually apply the logrotate configuration to test it:

   ```bash
   sudo logrotate -f /etc/logrotate.d/devopsfetch
   ```

## Usage

To run `devopsfetch`, use the following command:

```bash
./devopsfetch.sh [options]
```

### Available Options

- `-p`: Display all listening ports and their associated services.
- `-u`: Show information about user logins.
- `-n`: Retrieve Nginx domain configurations.
- `-d`: List Docker images and container statuses.
- `--time <start> <end>`: Retrieve logs and system information between specified times.
- `-h` or `--help`: Display help information.

**Examples:**

- Display all active ports:

  ```bash
  ./devopsfetch.sh -p
  ```

- Retrieve user login information:

  ```bash
  ./devopsfetch.sh -u
  ```

N.B: I know showing the log file is bad practice but I did it for submission purposes.

## Configuration

The tool stores its logs in the directory specified in the `install.sh` script. Ensure that this directory (`/mnt/c/Users/USER/devopsfetch/logs`) is correctly set up and has appropriate permissions. Update the paths in `install_devopsfetch.sh` and the `logrotate` configuration file as needed to fit your environment.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

HNG Stage 5 Mid-Task Submission - This project is part of the HNG internship program, focusing on practical DevOps tasks and tool development.
```