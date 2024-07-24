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
        echo "$(date) - Creating log directory: $LOG_DIR"
        mkdir -p "$LOG_DIR"
    fi
    for log_file in "$PORT_LOG" "$DOCKER_LOG" "$NGINX_LOG" "$USER_LOG" "$ACTIVITY_LOG"; do
        if [ ! -f "$log_file" ]; then
            touch "$log_file"
            echo "$(date) - Created log file: $log_file"
        fi
    done
}

log_ports() {
    echo "$(date) - Logging port information..."
    ss -tuln | awk '
        BEGIN { 
            print "------------------------------------------------------"
            print "| Port            | Protocol | State   | Service     |"
            print "------------------------------------------------------"
        }
        /LISTEN/ { 
            printf "| %-15s | %-8s | %-7s | %-11s |\n", $5, $1, $6, $7 
        }
        END { 
            print "------------------------------------------------------"
        }
    ' > "$PORT_LOG" 2>> "$ACTIVITY_LOG"
}

log_docker() {
    echo "$(date) - Logging Docker images and containers..."
    {
        echo "Docker Images:"
        echo "--------------------------------------------------------------"
        docker images --format "table | {{.Repository}} | {{.Tag}} | {{.ID}} | {{.CreatedAt}} |"
        echo "--------------------------------------------------------------"
        echo
        echo "Docker Containers:"
        echo "--------------------------------------------------------------"
        docker ps --format "table | {{.ID}} | {{.Image}} | {{.Command}} | {{.Status}} |"
        echo "--------------------------------------------------------------"
    } > "$DOCKER_LOG" 2>> "$ACTIVITY_LOG"
}

log_nginx() {
    echo "$(date) - Logging Nginx configuration..."
    nginx -T 2>/dev/null | awk '
        BEGIN { 
            print "------------------------------------------------------"
            print "| Domain         | Port      | Configuration         |"
            print "------------------------------------------------------"
        }
        /server_name/ { 
            printf "| %-15s | %-8s | %-22s |\n", $2, "Port Info", $0 
        }
        END { 
            print "------------------------------------------------------"
        }
    ' > "$NGINX_LOG" 2>> "$ACTIVITY_LOG"
}

log_users() {
    echo "$(date) - Logging user information..."
    last | awk '
        BEGIN { 
            print "------------------------------------------------------"
            print "| Username       | Last Login                       |"
            print "------------------------------------------------------"
        }
        { 
            printf "| %-15s | %-30s |\n", $1, $4 " " $5 " " $6 
        }
        END { 
            print "------------------------------------------------------"
        }
    ' > "$USER_LOG" 2>> "$ACTIVITY_LOG"
}

log_activities() {
    echo "$(date) - Logging system activities..."
    dmesg | awk '
        BEGIN { 
            print "------------------------------------------------------"
            print "| Time                 | Message                    |"
            print "------------------------------------------------------"
        }
        {
            timestamp = strftime("%Y-%m-%d %H:%M:%S", $1)
            printf "| %-20s | %-25s |\n", timestamp, $0
        }
        END { 
            print "------------------------------------------------------"
        }
    ' > "$ACTIVITY_LOG" 2>> "$ACTIVITY_LOG"
}


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

get_ports() {
    if [ -z "$1" ]; then
        cat "$PORT_LOG"
    else
        grep "$1" "$PORT_LOG" || echo "No information found for port: $1"
    fi
}

get_docker() {
    if [ -z "$1" ]; then
        cat "$DOCKER_LOG"
    else
        grep "$1" "$DOCKER_LOG" || echo "No information found for container: $1"
    fi
}

get_nginx() {
    if [ -z "$1" ]; then
        cat "$NGINX_LOG"
    else
        grep "$1" "$NGINX_LOG" || echo "No information found for domain: $1"
    fi
}

get_users() {
    if [ -z "$1" ]; then
        cat "$USER_LOG"
    else
        grep "$1" "$USER_LOG" || echo "No information found for user: $1"
    fi
}

timestamp_to_seconds() {
    date -d"$1" +%s
}

get_time_range() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: $0 -t [start_time] [end_time]"
        return
    fi
    
    start=$(timestamp_to_seconds "$1")
    end=$(timestamp_to_seconds "$2")
    
    if [[ -z "$start" || -z "$end" ]]; then
        echo "Invalid time format. Please use a valid date string."
        return
    fi

    export TZ=UTC
    awk -v start="$start" -v end="$end" '{
        current_time = $1
        if (current_time >= start && current_time <= end) {
            print $0
        }
    }' "$ACTIVITY_LOG"
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

main "$@"
