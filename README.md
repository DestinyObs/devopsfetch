### README.md

Here's the `README.md` file in markdown format:

```markdown
# DevOps Fetch Tool

## Overview
`devopsfetch` is a tool for retrieving and monitoring system information, including active ports, user logins, Nginx configurations, Docker images, and container statuses. It uses a systemd service for continuous monitoring and logging.

## Installation

### Prerequisites
Ensure the following dependencies are installed:
- awk
- grep
- touch
- mkdir

### Installation Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/DestinyObs/devopsfetch.git
   cd devopsfetch
   ```

2. Run the installation script:
   ```bash
   chmod +x install_devopsfetch.sh
   ./install_devopsfetch.sh
   ```

## Usage
The following command-line flags are available:

- `-p, --port [port]`: Display all ports and services, or detailed info for a specific port.
- `-d, --docker [container]`: List Docker images/containers or details for a specific container.
- `-n, --nginx [domain]`: Display Nginx domains/ports or details for a specific domain.
- `-u, --users [username]`: List all users or details for a specific user.
- `-t, --time [start end]`: Display activities within a specified time range.
- `-h, --help`: Show this help message.

### Examples
```bash
# Display all active ports
./devopsfetch.sh -p

# Display detailed information for port 80
./devopsfetch.sh -p 80

# List all Docker images and containers
./devopsfetch.sh -d

# Display detailed information for a specific container
./devopsfetch.sh -d container_name

# Display all Nginx domains and their ports
./devopsfetch.sh -n

# Display detailed configuration for a specific domain
./devopsfetch.sh -n domain.com

# List all users and their last login times
./devopsfetch.sh -u

# Display detailed information for a specific user
./devopsfetch.sh -u username

# Display activities within a specified time range
./devopsfetch.sh -t "start_time" "end_time"
```

## Logging
Logs are stored in `/devopsfetch/logs/` with automatic log rotation configured via `logrotate`.

## Contributing
Please feel free to submit issues, fork the repository, and send pull requests!

## License
This project is licensed under the MIT License.
```