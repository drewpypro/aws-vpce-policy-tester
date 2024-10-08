import argparse
import subprocess
import json
import sys
import csv
import datetime
import re
import time

# Load AWS CLI command database
def load_service_commands():
    file_path = "/home/ec2-user/aws_commands.json"
    try:
        with open(file_path, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: Command Database {file_path} not found.")
        sys.exit(1)

# Function to run AWS CLI commands and check for VPC endpoint policy block
def run_aws_command(command):
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        output = result.stdout if result.returncode == 0 else result.stderr

        # Scrub account ID and other sensitive information
        sanitized_output = output.replace("VAR_ACCOUNT_ID", "[ACCOUNT_ID]")
        sanitized_output = sanitized_output.replace("source_ssh_net", "[PUBLIC_SSH_IP]")
        # Obfuscate sensitive credentials in the result
        sanitized_output = re.sub(r'"AccessKeyId":\s*"[^"]+"', '"AccessKeyId": "[REDACTED]"', sanitized_output)
        sanitized_output = re.sub(r'"SecretAccessKey":\s*"[^"]+"', '"SecretAccessKey": "[REDACTED]"', sanitized_output)
        sanitized_output = re.sub(r'"SessionToken":\s*"[^"]+"', '"SessionToken": "[REDACTED]"', sanitized_output)

        if "AWS.SimpleQueueService.NonExistentQueue" in sanitized_output:
            verdict = "Queue does not exist"
        elif "explicit deny in a VPC endpoint policy" in sanitized_output:
            verdict = "Denied by VPC Endpoint Policy"
        elif "because no VPC endpoint policy" in sanitized_output:
            verdict = "Denied by VPC Endpoint Policy"
        elif "sleep" in sanitized_output:
            verdict = "Sleep Command"
        elif "wait" in sanitized_output:
            verdict = "Wait Command"
        else:
            verdict = "Allowed by VPC Endpoint Policy"
        return sanitized_output, verdict

    except Exception as e:
        return f"Error running command: {command}\n{str(e)}", "Error"

# Create a timestamp for filenames
timestamp = datetime.datetime.now().strftime("%b%d-%H%M")

# Function to test services and write results to file
def test_services(service_commands, output_mode, option_desc):
    if output_mode in ['log', 'both']:
        log_file = f"OPTION_DESCRIPTION-{timestamp}-log.txt"
        log = open(log_file, 'w')

    if output_mode in ['report', 'both']:
        report_file = f"OPTION_DESCRIPTION-{timestamp}-report.csv"
        report = open(report_file, 'w', newline='')
        writer = csv.writer(report)
        writer.writerow(["Command", "Verdict", "Option Description"])

    for service, commands in service_commands.items():
        message = f"\nTesting VPC Endpoint Policy configured with OPTION_DESCRIPTION for service: {service}"
        print(message)
        if output_mode in ['log', 'both']:
            log.write(message + "\n")

        for cmd in commands:
            scrubbed_cmd = cmd.replace("VAR_ACCOUNT_ID", "[ACCOUNT_ID]")
            result, verdict = run_aws_command(cmd)
            message = f"Command: {scrubbed_cmd}\nResult: {result}\nVerdict: {verdict}"
            print(message)
            if output_mode in ['log', 'both']:
                log.write(message + "\n")
            if output_mode in ['report', 'both']:
                writer.writerow([scrubbed_cmd, verdict, option_desc])

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
    parser = argparse.ArgumentParser()

    parser.add_argument('--log', action='store_true', help='Generate log file output.')
    parser.add_argument('--report', action='store_true', help='Generate report file output in CSV format.')
    parser.add_argument('--both', action='store_true', help='Generate both log and report file output.')
    parser.add_argument('--shell', action='store_true', help='Output only to shell without writing files.')

    args = parser.parse_args()

    if not (args.log or args.report or args.both or args.shell):
        show_usage()
        sys.exit(0)

    # Record the start time
    start_time = datetime.datetime.now()

    # Load the AWS CLI commands from the command database
    service_commands = load_service_commands()

    option_desc = "OPTION_DESCRIPTION"
    output_mode = 'log' if args.log else 'report' if args.report else 'both' if args.both else 'shell'

    # Run tests and write to file if requested.
    test_services(service_commands, output_mode, option_desc)
    
    #Record the end time
    end_time = datetime.datetime.now()
    
    #Calculate elapsed time
    elaspsed_time = end_time - start_time
    
    print(f"Elapsed time: {elaspsed_time}")    
    print(f"Testing of the OPTION_DESCRIPTION condition completed. Results have been written to OPTION_DESCRIPTION-{timestamp}-log.txt and report to OPTION_DESCRIPTION-{timestamp}-report.csv")

if __name__ == "__main__":
    main()