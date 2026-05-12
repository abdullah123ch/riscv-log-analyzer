# RISC-V Log Analyzer

## Project Overview
[cite_start]The **RISC-V Log Analyzer** is a professional-grade shell-based tool designed to automate the processing of simulation log files[cite: 1240]. [cite_start]It extracts critical verification metrics, calculates performance statistics, and generates structured reports for hardware design workflows[cite: 1241].

[cite_start]This project was developed as the Capstone Assignment for **Module 1** of the MEDS Lab Summer Training 2026[cite: 1234].

## Features
* [cite_start]**Log Parsing**: Extracts total tests, PASS/FAIL/SKIP counts, and pass rates[cite: 1258, 1259, 1260].
* [cite_start]**Timing Analysis**: Calculates min, max, and average execution times per test[cite: 1262, 1263].
* [cite_start]**Error Reporting**: Identifies and lists specific failing test names[cite: 1261].
* [cite_start]**Flexible Output**: Supports both human-readable text and machine-parseable CSV formats[cite: 1255].
* [cite_start]**Automation**: Fully integrated with a Makefile for environment setup, testing, and report generation[cite: 1278].

## Repository Structure
```text
riscv-log-analyzer/
├── README.md              # Project description and overview
├── Makefile               # Build and run automation
├── .gitignore             # Git ignore rules for artifacts
├── scripts/
│   ├── analyze.sh         # Main analysis engine
│   ├── setup_env.sh       # Toolchain validation script
│   └── generate_report.sh # Batch report aggregator
├── test_data/             # Sample RISC-V simulation logs
├── output/                # Generated reports (gitignored)
└── docs/
    └── USAGE.md           # Detailed command reference