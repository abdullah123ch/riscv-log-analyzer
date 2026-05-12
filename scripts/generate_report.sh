#!/bin/bash
# Part of MEDS Lab Module 1 Grand Assignment [cite: 1241]
set -euo pipefail

# --- Configuration ---
LOG_DIR="test_data"
OUTPUT_DIR="output"
REPORT_FILE="$OUTPUT_DIR/summary_report.txt"

# Ensure the output directory exists [cite: 1244]
mkdir -p "$OUTPUT_DIR"

# --- Functions ---

# Function to append a separator to the report 
write_header() {
    echo "==========================================" >> "$REPORT_FILE"
    echo "   RISC-V BATCH SIMULATION REPORT" >> "$REPORT_FILE"
    echo "   Generated on: $(date)" >> "$REPORT_FILE"
    echo "==========================================" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

# --- Main Execution ---

echo "Generating aggregate report from $LOG_DIR..."

# Clear any previous report 
> "$REPORT_FILE"

write_header

# Loop through all log files in test_data [cite: 1279]
for log in "$LOG_DIR"/*.log; do
    if [ -f "$log" ]; then
        echo "Processing $(basename "$log")..."
        
        # Call the main analyzer script for each log [cite: 1279]
        # Append the text output to our master report
        ./scripts/analyze.sh "$log" >> "$REPORT_FILE"
        echo -e "\n------------------------------------------\n" >> "$REPORT_FILE"
    fi
done

echo "Report generation complete: $REPORT_FILE"