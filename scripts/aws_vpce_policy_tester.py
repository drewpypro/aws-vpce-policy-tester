import argparse
import subprocess
import json
import sys
import csv
import datetime

# Load AWS CLI commands from a hard-coded file path
def load_service_commands():
    file_path = "/home/ec2-user/aws_commands.json"
    try:
        with open(file_path, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: The file {file_path} was not found.")
        sys.exit(1)

# Function to run AWS CLI commands and check for VPC endpoint policy block
def run_aws_command(command):
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        output = result.stdout if result.returncode == 0 else result.stderr
        if "explicit deny in a VPC endpoint policy" in output:
            verdict = "Blocked by VPC Endpoint Policy"
        else:
            verdict = "Command Allowed by VPC Endpoint Policy"
        return output, verdict
    except Exception as e:
        return f"Error running command: {command}\n{str(e)}", "Error"

# Create a timestamp for filenames
timestamp = datetime.datetime.now().strftime("%b%d-%H%M")

# Function to test services and write results to a report
def test_services(service_commands, output_mode, option_desc):
    if output_mode in ['log', 'both']:
        log_file = f"{timestamp}-log.txt"
        log = open(log_file, 'w')

    if output_mode in ['report', 'both']:
        report_file = f"{timestamp}-report.csv"
        report = open(report_file, 'w', newline='')
        writer = csv.writer(report)
        writer.writerow(["Command", "Verdict", "Option Description"])  # CSV headers

    for service, commands in service_commands.items():
        message = f"\nTesting VPC Endpoint Policy for service: {service}"
        if output_mode in ['log', 'both']:
            log.write(message + "\n")
        if output_mode in ['shell', 'both']:
            print(message)

        for cmd in commands:
            result, verdict = run_aws_command(cmd)
            message = f"Command: {cmd}\nResult: {result}\nVerdict: {verdict}"
            if output_mode in ['log', 'both']:
                log.write(message + "\n")
            if output_mode in ['shell', 'both']:
                print(message)
            if output_mode in ['report', 'both']:
                writer.writerow([cmd, verdict, option_desc])

    if output_mode in ['log', 'both']:
        log.close()
    if output_mode in ['report', 'both']:
        report.close()

# Function to display options and explain usage
def show_usage():
    print("""
    Usage: python aws-vpce-policy-tester.py [OPTIONS]

    Options:
    --log          Generate a full log file with $day/hour/minute-log.txt.
    --report       Generate a CSV report with $day/hour/minute-report.csv (command, verdict, option description).
    --both         Generate both log and report files.
    --shell        Output only to the shell without writing any files.
    
    Examples:
    python aws-vpce-policy-tester.py --log
    python aws-vpce-policy-tester.py --report
    python aws-vpce-policy-tester.py --both
    python aws-vpce-policy-tester.py --shell
    """)

# Main function to parse arguments and trigger tests
def main():
    parser = argparse.ArgumentParser(add_help=False)

    parser.add_argument('--log', action='store_true', help='Generate log file output.')
    parser.add_argument('--report', action='store_true', help='Generate report file output in CSV format.')
    parser.add_argument('--both', action='store_true', help='Generate both log and report file output.')
    parser.add_argument('--shell', action='store_true', help='Output only to shell without writing files.')
    parser.add_argument('--option-description', type=str, help='Option description for the report')

    args = parser.parse_args()

    if not (args.log or args.report or args.both or args.shell):
        show_usage()
        sys.exit(0)

    # Load the AWS CLI commands from the aws_commands.json file located at /home/ec2-user/
    service_commands = load_service_commands()

    option_desc = args.option_description
    output_mode = 'log' if args.log else 'report' if args.report else 'both' if args.both else 'shell'

    # Run the tests and write the report
    test_services(service_commands, output_mode, option_desc)
    print(f"Testing completed. Results have been written to {timestamp}.")