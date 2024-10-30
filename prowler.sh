#!/bin/bash

# Variables
OUTPUT_DIR="./prowler-reports"  # Directory to store reports
SLACK_WEBHOOK_URL="$SLACK_WEBHOOK_URL"  # Fetch from environment variable

# Get AWS Account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null)
if [[ $? -ne 0 ]]; then
    echo "Error fetching account ID."
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run Prowler (ensure Prowler is executable and in the correct path)
chmod +x ./prowler.sh  # Ensure Prowler is executable
./prowler.sh -M csv -o "$OUTPUT_DIR/report_$ACCOUNT_ID.csv"
if [[ $? -ne 0 ]]; then
    echo "Prowler scan failed."
    exit 1
fi

# Check if the report was generated
REPORT_PATH="$OUTPUT_DIR/report_$ACCOUNT_ID.csv"
if [ -f "$REPORT_PATH" ]; then
    # Send the report to Slack
    curl -F file=@"$REPORT_PATH" \
         -F "initial_comment=AWS Security Report for Account ID: $ACCOUNT_ID" \
         -F channels=#your-channel \
         -H "Authorization: Bearer $SLACK_BEARER_TOKEN" \
         "$SLACK_WEBHOOK_URL"
         
    if [[ $? -eq 0 ]]; then
        echo "Report sent to Slack!"
    else
        echo "Failed to send report to Slack."
        exit 1
    fi
else
    echo "Report generation failed!"
    exit 1
fi
