#!/usr/bin/python3

import argparse
import subprocess
import time
from tabulate import tabulate
import logging

# Configure logging
logging.basicConfig(filename='/var/log/devopsfetch.log', level=logging.INFO, 
                    format='%(asctime)s - %(message)s')

def log_and_return(output):
    logging.info(output)
    return output

def get_ports():
    result = subprocess.run(['ss', '-tuln'], capture_output=True, text=True)
    lines = result.stdout.splitlines()
    headers = lines[0].split()
    rows = [line.split() for line in lines[1:]]
    return log_and_return(tabulate(rows, headers, tablefmt="pretty"))

def get_port_details(port):
    result = subprocess.run(['ss', '-tuln'], capture_output=True, text=True)
    lines = result.stdout.splitlines()
    for line in lines:
        if f":{port} " in line:
            return log_and_return(line)
    return log_and_return("Port not found.")

def get_docker_images():
    result = subprocess.run(['docker', 'images'], capture_output=True, text=True)
    lines = result.stdout.splitlines()
    headers = lines[0].split()
    rows = [line.split() for line in lines[1:]]
    return log_and_return(tabulate(rows, headers, tablefmt="pretty"))

def get_docker_container_details(container_name):
    result = subprocess.run(['docker', 'inspect', container_name], capture_output=True, text=True)
    return log_and_return(result.stdout)

def get_nginx_domains():
    result = subprocess.run(['grep', 'server_name', '/etc/nginx/sites-available/*'], capture_output=True, text=True)
    return log_and_return(result.stdout)

def get_nginx_domain_details(domain):
    result = subprocess.run(['grep', '-R', f'server_name {domain};', '/etc/nginx/sites-available/'], capture_output=True, text=True)
    return log_and_return(result.stdout)

def get_users():
    result = subprocess.run(['last'], capture_output=True, text=True)
    lines = result.stdout.splitlines()
    headers = ["Username", "Terminal", "IP Address", "Date", "Time", "Duration"]
    rows = [line.split()[:6] for line in lines if line]
    return log_and_return(tabulate(rows, headers, tablefmt="pretty"))

def get_user_details(username):
    result = subprocess.run(['last', username], capture_output=True, text=True)
    return log_and_return(result.stdout)

def parse_arguments():
    parser = argparse.ArgumentParser(description="devopsfetch - System Information Retrieval and Monitoring Tool")
    parser.add_argument('-p', '--port', nargs='?', const=True, help='Display all active ports or detailed information for a specific port')
    parser.add_argument('-d', '--docker', nargs='?', const=True, help='List all Docker images and containers or detailed information for a specific container')
    parser.add_argument('-n', '--nginx', nargs='?', const=True, help='Display all Nginx domains or detailed configuration for a specific domain')
    parser.add_argument('-u', '--users', nargs='?', const=True, help='List all users or detailed information for a specific user')
    parser.add_argument('-t', '--time', help='Display activities within a specified time range')
    parser.add_argument('-m', '--monitor', action='store_true', help='Run in continuous monitoring mode')
    return parser.parse_args()

def main():
    args = parse_arguments()
    if args.monitor:
        while True:
            if args.port:
                print(get_ports() if args.port is True else get_port_details(args.port))
            if args.docker:
                print(get_docker_images() if args.docker is True else get_docker_container_details(args.docker))
            if args.nginx:
                print(get_nginx_domains() if args.nginx is True else get_nginx_domain_details(args.nginx))
            if args.users:
                print(get_users() if args.users is True else get_user_details(args.users))
            time.sleep(60)  # Monitor every minute
    else:
        if args.port:
            print(get_ports() if args.port is True else get_port_details(args.port))
        elif args.docker:
            print(get_docker_images() if args.docker is True else get_docker_container_details(args.docker))
        elif args.nginx:
            print(get_nginx_domains() if args.nginx is True else get_nginx_domain_details(args.nginx))
        elif args.users:
            print(get_users() if args.users is True else get_user_details(args.users))
        elif args.time:
            print(f"Time range filter not implemented yet for: {args.time}")
        else:
            print("Please provide a valid flag. Use -h or --help for usage instructions.")

if __name__ == "__main__":
    main()
