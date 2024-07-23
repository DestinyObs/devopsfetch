#!/bin/bash

# Define log directory and files
LOG_DIR="/mnt/c/Users/USER/devopsfetch/logs"
PORT_LOG="$LOG_DIR/ports.log"
DOCKER_LOG="$LOG_DIR/docker_images.log"
NGINX_LOG="$LOG_DIR/nginx_domains.log"
USER_LOG="$LOG_DIR/users.log"
ACTIVITY_LOG="$LOG_DIR/activities.log"

# Function to create log directory and files if they don't exist
setup_logs() {
    if [ ! -d "$LOG_DIR" ]; then
        echo "Creating log directory: $LOG_DIR"
        mkdir -p "$LOG_DIR"
    fi
    # Create log files if they don't exist
    touch "$PORT_LOG" "$DOCKER_LOG" "$NGINX_LOG" "$USER_LOG" "$ACTIVITY_LOG"
}

# Collect and log port information
log_ports() {
    echo "Logging port information..."
    ss -tuln > "$PORT_LOG"
}

# Collect and log Docker information
log_docker() {
    echo "Logging Docker images..."
    docker images > "$DOCKER_LOG"
    echo "Logging Docker containers..."
    docker ps >> "$DOCKER_LOG" # Append running containers
}

# Collect and log Nginx information
log_nginx() {
    echo "Logging Nginx configuration..."
    nginx -T > "$NGINX_LOG" # Full Nginx configuration
}

# Collect and log user information
log_users() {
    echo "Logging user information..."
    last > "$USER_LOG"
}

# Collect and log system activity information
log_activities() {
    echo "Logging system activities..."
    dmesg > "$ACTIVITY_LOG"
}

# Display help
show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -p, --port [port]        Display all ports and services, or detailed info for a specific port"
    echo "  -d, --docker [container] List Docker images/containers or details for a specific container"
    echo "  -n, --nginx [domain]     Display Nginx domains/ports or details for a specific domain"
    echo "  -u, --users [username]   List all users or details for a specific user"
    echo "  -t, --time [start end]   Display activities within a specified time range"
    echo "  -h, --help               Show this help message"
}

# Retrieve and display ports
get_ports() {
    if [ -z "$1" ]; then
        cat "$PORT_LOG" | grep LISTEN
    else
        grep "$1" "$PORT_LOG"
    fi
}

# Retrieve and display Docker info
get_docker() {
    if [ -z "$1" ]; then
        cat "$DOCKER_LOG"
    else
        grep "$1" "$DOCKER_LOG"
    fi
}

# Retrieve and display Nginx info
get_nginx() {
    if [ -z "$1" ]; then
        cat "$NGINX_LOG"
    else
        grep "$1" "$NGINX_LOG"
    fi
}

# Retrieve and display user info
get_users() {
    if [ -z "$1" ]; then
        cat "$USER_LOG"
    else
        grep "$1" "$USER_LOG"
    fi
}

# Retrieve and display time range activities
get_time_range() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: $0 -t [start_time] [end_time]"
        return
    fi
    awk -v start="$1" -v end="$2" '$0 >= start && $0 <= end' "$ACTIVITY_LOG"
}

# Main function to handle options
main() {
    setup_logs

    while true; do
        log_ports
        log_docker
        log_nginx
        log_users
        log_activities

        case "$1" in
            -p|--port) get_ports "$2" ;;
            -d|--docker) get_docker "$2" ;;
            -n|--nginx) get_nginx "$2" ;;
            -u|--users) get_users "$2" ;;
            -t|--time) get_time_range "$2" "$3" ;;
            -h|--help) show_help ;;
            *) echo "Unknown option: $1"; show_help ;;
        esac

        sleep 60
    done
}

# Run the main function with provided arguments
main "$@"
