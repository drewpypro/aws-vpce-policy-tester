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

# Function to run AWS CLI commands
def run_aws_command(command):
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        return result.stdout if result.returncode == 0 else result.stderr
    except Exception as e:
        return f"Error running command: {command}\n{str(e)}"

# Function to test services and write results to a report
def test_services(service_commands, output_file):
    with open(output_file, 'w') as report:
        for service, commands in service_commands.items():
            report.write(f"\nTesting VPC Endpoint Policy for service: {service}\n")
            for cmd in commands:
                result = run_aws_command(cmd)
                report.write(f"\nCommand: {cmd}\nResult: {result}\n")

# Function to display options and explain usage
def show_usage():
    print("""
    Usage: python aws-vpce-policy-tester.py [OPTIONS]

    Options:
    --condition CONDITION   Test condition type (e.g., org-id, principal-account, resource-account, ou-path)
    --output OUTPUT         Specify the output report file (e.g., report.txt)

    Examples:
    python aws-vpce-policy-tester.py --condition org-id --output report.txt
    python aws-vpce-policy-tester.py --condition principal-account --output result.txt

    If no options are provided, this help message will be shown.
    """)

# Main function to parse arguments and trigger tests
def main():
    parser = argparse.ArgumentParser(add_help=False)

    parser.add_argument('--condition', type=str, help='Test condition type (e.g., org-id, principal-account, service-account, ou-path)')
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
