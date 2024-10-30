import os
import subprocess
import requests
from datetime import datetime

# Configuration
SLACK_WEBHOOK_URL = os.getenv('SLACK_WEBHOOK_URL')
SLACK_BOT_TOKEN = os.getenv('SLACK_BOT_TOKEN')
PROWLER_OUTPUT_DIR = 'prowler-output'
SCAN_TIMESTAMP = datetime.now().strftime("%Y%m%d%H%M%S")

def run_prowler():
    os.makedirs(PROWLER_OUTPUT_DIR, exist_ok=True)

    json_report_path = f"{PROWLER_OUTPUT_DIR}/prowler_report_{SCAN_TIMESTAMP}.json"
    csv_report_path = f"{PROWLER_OUTPUT_DIR}/prowler_report_{SCAN_TIMESTAMP}.csv"
    
    # Command to run Prowler (assuming prowler.sh is in the Prowler directory)
    command = f"./Prowler/prowler.sh -M json,csv -o {PROWLER_OUTPUT_DIR}/prowler_report_{SCAN_TIMESTAMP}"

    result = subprocess.run(command, shell=True, capture_output=True, text=True)

    if result.returncode != 0:
        print("Prowler scan failed.")
        print(result.stderr)
        return None, None

    return json_report_path, csv_report_path

def send_file_to_slack(file_path):
    with open(file_path, 'rb') as file:
        response = requests.post(
            "https://slack.com/api/files.upload",
            headers={'Authorization': f'Bearer {SLACK_BOT_TOKEN}'},
            files={'file': file},
            data={'channels': '#your-channel'},  # Replace with your channel name
        )

    if response.status_code != 200:
        print(f"Failed to send file to Slack: {response.status_code}, {response.text}")

def main():
    json_report, csv_report = run_prowler()
    if json_report and csv_report:
        send_file_to_slack(json_report)
        send_file_to_slack(csv_report)

if __name__ == "__main__":
    main()
