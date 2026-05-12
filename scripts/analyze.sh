#!/bin/bash

# Part A: Shell Scripts - riscv-log-analyzer [cite: 1246]
# The "holy trinity" of Bash safety for robust automation [cite: 747, 1265]
set -euo pipefail

# --- Configuration & Defaults ---
LOG_FILE=""
FORMAT="text"
OUTPUT="/dev/stdout"
VERBOSE=0

# --- Functions --- [cite: 1267]

# Function 1: Display usage information [cite: 1256, 1292]
show_help() {
    cat << EOF
Usage: $(basename "$0") <log_file> [options]

Arguments:
  \$1                  Path to the RISC-V simulation log file (required) [cite: 1248]

Options:
  --format [text|csv]  Set output format (default: text) [cite: 1255]
  --output <path>      Set output file path (default: stdout) [cite: 1255]
  --verbose            Enable detailed processing information [cite: 1255]
  --help               Display this help message [cite: 1256]

EOF
}

# Function 2: Perform the core log analysis [cite: 1257]
analyze_log() {
    local file=$1
    
    # Extract basic counts using grep -c [cite: 495, 511, 514]
    local total_tests=$(grep -c "TEST START:" "$file")
    local pass_count=$(grep -c "TEST PASS:" "$file")
    local fail_count=$(grep -c "TEST FAIL:" "$file")
    local skip_count=$(grep -c "TEST SKIP:" "$file")

    # Guard against division by zero if log is empty [cite: 1266]
    local pass_rate="0.0"
    if [ "$total_tests" -gt 0 ]; then
        # Calculate pass rate percentage [cite: 1260, 591]
        pass_rate=$(awk "BEGIN {printf \"%.1f\", ($pass_count/$total_tests)*100}")
    fi

    # Extract execution times for statistics [cite: 1262]
    # Uses awk to find the string inside () and remove the 's' [cite: 506, 511]
    local times=$(grep -oP "TEST (PASS|FAIL):.*?\(\K[0-9.]+(?=s\))" "$file")
    
    local min_time="N/A"
    local max_time="N/A"
    local avg_time="N/A"

    if [ -n "$times" ]; then
        # Summary statistics calculation [cite: 1263, 512]
        min_time=$(echo "$times" | sort -n | head -n 1)
        max_time=$(echo "$times" | sort -n | tail -n 1)
        avg_time=$(echo "$times" | awk '{sum+=$1} END {if (NR>0) printf "%.2f", sum/NR}')
    fi

    # --- Output Generation --- [cite: 1312]
    {
        if [ "$FORMAT" == "text" ]; then
            echo "=== RISC-V Simulation Log Analysis ==="
            echo "Log file: $file"
            echo "Analysis date: $(date '+%Y-%m-%d %H:%M:%S')"
            echo ""
            echo "--- Results Summary ---"
            echo "Total tests: $total_tests" [cite: 1258]
            echo "Passed:      $pass_count ($pass_rate%)" [cite: 1259, 1260]
            echo "Failed:      $fail_count" [cite: 1259]
            echo "Skipped:     $skip_count" [cite: 1259]
            echo ""
            echo "--- Failed Tests ---" [cite: 1261]
            grep "TEST FAIL:" "$file" | awk '{print "  " NR ". " $5}' || echo "  None"
            echo ""
            echo "--- Timing Statistics ---" [cite: 1263]
            echo "Min time:    ${min_time}s"
            echo "Max time:    ${max_time}s"
            echo "Avg time:    ${avg_time}s"
            echo ""
            echo "--- Verdict: $( [ "$fail_count" -eq 0 ] && echo "PASS" || echo "FAIL" ) ---"
        else
            # CSV Format Support [cite: 1255]
            echo "total_tests,pass,fail,skip,pass_rate,min_time,max_time,avg_time"
            echo "$total_tests,$pass_count,$fail_count,$skip_count,$pass_rate,$min_time,$max_time,$avg_time"
        fi
    } > "$OUTPUT"

    # Return exit code 1 if any tests failed [cite: 1269]
    [ "$fail_count" -eq 0 ] || return 1
}

# --- Argument Parsing --- [cite: 1247]

# Check for mandatory first argument [cite: 1248, 1266]
if [[ $# -lt 1 ]] || [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

LOG_FILE="$1"
shift # Remove log file from argument list to parse flags

# Simple manual parsing for flags [cite: 704, 706]
while [[ $# -gt 0 ]]; do
    case "$1" in
        --format)
            FORMAT="$2"
            shift 2
            ;;
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=1
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# --- Error Handling & Execution --- [cite: 1266]

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' not found."
    exit 1
fi

if [ "$VERBOSE" -eq 1 ]; then
    echo "[INFO] Starting analysis of $LOG_FILE..."
fi

# Run analysis and capture exit status [cite: 694, 739, 1269]
analyze_log "$LOG_FILE"