#!/bin/bash
# Part of MEDS Lab Module 1 Grand Assignment [cite: 331, 332]
set -euo pipefail

# --- Functions ---

# Function to check if a command exists in the current PATH 
check_tool() {
    local tool_name=$1
    if command -v "$tool_name" &> /dev/null; then
        echo "[OK] $tool_name is installed: $(which "$tool_name")"
    else
        echo "[ERROR] $tool_name is NOT found in PATH. Please install it to continue."
        return 1
    fi
}

# --- Main Execution ---

echo "=== MEDS Lab Environment Setup Check ==="
echo "Checking for essential development tools..."

# List of required tools based on Section 6 and Assignment requirements [cite: 252, 1283]
tools=("bash" "grep" "awk" "sed" "make" "git" "riscv64-unknown-elf-gcc" "verilator")

errors=0
for tool in "${tools[@]}"; do
    check_tool "$tool" || errors=$((errors + 1))
done

if [ "$errors" -eq 0 ]; then
    echo "----------------------------------------"
    echo "Environment check PASSED. You are ready for Week 1." [cite: 14]
    exit 0
else
    echo "----------------------------------------"
    echo "Environment check FAILED. Missing $errors tool(s)."
    exit 1
fi