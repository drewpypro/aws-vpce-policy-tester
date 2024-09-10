import argparse
import subprocess
import json
import sys

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
        if "because no VPC endpoint policy allows" in output:
            verdict = "Blocked by VPC Endpoint Policy"
        else:
            verdict = "Command Allowed by VPC Endpoint Policy"
        return output, verdict
    except Exception as e:
        return f"Error running command: {command}\n{str(e)}", "Error"

# Function to print to both console and file
def log_to_console_and_file(report, message):
    print(message)  # Output to console
    report.write(message + "\n")  # Write to the file

# Function to test services and write results to a report
def test_services(service_commands, output_file):
    with open(output_file, 'w') as report:
        for service, commands in service_commands.items():
            log_to_console_and_file(report, f"\nTesting VPC Endpoint Policy for service: {service}")
            for cmd in commands:
                result, verdict = run_aws_command(cmd)
                log_to_console_and_file(report, f"\nCommand: {cmd}\nResult: {result}\nVerdict: {verdict}")

# Function to display options and explain usage
def show_usage():
    print("""
    Usage: python aws-vpce-policy-tester.py [OPTIONS]

    Options:
    --output OUTPUT         Specify the output report file (e.g., report.txt)

    Examples:
    python aws-vpce-policy-tester.py --output report.txt

    If no options are provided, this help message will be shown.
    """)

# Main function to parse arguments and trigger tests
def main():
    parser = argparse.ArgumentParser(add_help=False)

    parser.add_argument('--output', type=str, help='Specify the output report file (e.g., report.txt)')

    args = parser.parse_args()

    if not args.condition or not args.output:
        show_usage()
        sys.exit(0)

    # Load the AWS CLI commands from the aws_commands.json file located at /home/ec2-user/
    service_commands = load_service_commands()

    # Log the options selected by the user
    print(f"Condition selected: {args.condition}")
    print(f"Output will be written to: {args.output}")

    # Run the tests and write the report
    test_services(service_commands, args.output)
    print(f"Testing completed. Results have been written to {args.output}.")

if __name__ == "__main__":
    main()
