# DevOps Fetch

## Overview

DevOps Fetch is a tool for retrieving and monitoring system information. It collects and displays details about active ports, Docker images and containers, Nginx configurations, user logins, and system activities within a specified time range.

## Installation

### Prerequisites

- Ubuntu or Debian-based system
- `nginx` installed
- `docker` installed
- `systemd` installed

### Steps

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/devopsfetch.git
    cd devopsfetch
    ```

2. Run the installation script:
    ```bash
    sudo ./install.sh
    ```

## Usage

### Commands

- Display all active ports and services:
    ```bash
    devopsfetch -p
    ```

- Provide detailed information about a specific port:
    ```bash
    devopsfetch -p <port_number>
    ```

- List all Docker images and containers:
    ```bash
    devopsfetch -d
    ```

- Provide detailed information about a specific container:
    ```bash
    devopsfetch -d <container_name>
    ```

- Display all Nginx domains and their ports:
    ```bash
    devopsfetch -n
    ```

- Provide detailed configuration information for a specific domain:
    ```bash
    devopsfetch -n <domain>
    ```

- List all users and their last login times:
    ```bash
    devopsfetch -u
    ```

- Provide detailed information about a specific user:
    ```bash
    devopsfetch -u <username>
    ```

- Display activities within a specified time range:
    ```bash
    devopsfetch -t "<start_time>" "<end_time>"
    ```

- Show help message:
    ```bash
    devopsfetch -h
    ```

## Logging

Logs are stored in the `/mnt/c/Users/USER/devopsfetch/logs` directory. Log rotation is managed by `logrotate` and configured to rotate logs daily, keeping up to 7 compressed log files.

## Contributions

Contributions are welcome. Please fork the repository and submit a pull request.
