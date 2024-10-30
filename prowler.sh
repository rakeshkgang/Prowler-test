#!/bin/bash


# Variables
PROWLER_DIR="/path/to/prowler"  # Update with the path to your Prowler directory
OUTPUT_DIR="./prowler-reports"   # Directory to store reports
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK"  # Your Slack webhook URL
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Navigate to Prowler directory
cd "$PROWLER_DIR" || exit

# Run Prowler and generate a report in CSV format
./prowler -M csv -o "$OUTPUT_DIR/report_$ACCOUNT_ID.csv"

# Check if the report was generated
if [ -f "$OUTPUT_DIR/report_$ACCOUNT_ID.csv" ]; then
    # Send the report to Slack
    curl -F file=@"$OUTPUT_DIR/report_$ACCOUNT_ID.csv" \
         -F "initial_comment=AWS Security Report for Account ID: $ACCOUNT_ID" \
         -F channels=#your-channel \
         -H "Authorization: Bearer ${{ secrets.SLACK_BEARER_TOKEN }}" \
         https://slack.com/api/files.upload

    echo "Report sent to Slack!"
else
    echo "Report generation failed!"
    exit 1
fi

=======
# Variables
OUTPUT_DIR="./prowler-reports"  # Directory to store reports
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK"  # Your Slack webhook URL
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run Prowler and generate a report in CSV format
./prowler.sh -M csv -o "$OUTPUT_DIR/report_$ACCOUNT_ID.csv"

# Check if the report was generated
if [ -f "$OUTPUT_DIR/report_$ACCOUNT_ID.csv" ]; then
    # Send the report to Slack
    curl -F file=@"$OUTPUT_DIR/report_$ACCOUNT_ID.csv" \
         -F "initial_comment=AWS Security Report for Account ID: $ACCOUNT_ID" \
         -F channels=#your-channel \
         -H "Authorization: Bearer ${{ secrets.SLACK_BEARER_TOKEN }}" \
         https://slack.com/api/files.upload

    echo "Report sent to Slack!"
else
    echo "Report generation failed!"
    exit 1
fi

>>>>>>> 397ca83bcca7eeb840c476283ec656d28c491e37