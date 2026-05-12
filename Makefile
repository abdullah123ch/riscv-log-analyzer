# Part C: Makefile - riscv-log-analyzer [cite: 351, 1277]

# --- Variables --- 
SHELL := /bin/bash
LOG_DIR = test_data
SCRIPTS_DIR = scripts
OUTPUT_DIR = output

# --- Phony Targets --- [cite: 1162, 1432]
.PHONY: all test report clean help setup

# 1. all: Run the analyzer on all test log files [cite: 1279]
all: setup
	@echo "Running analyzer on all logs in $(LOG_DIR)..."
	@for log in $(LOG_DIR)/*.log; do \
		./$(SCRIPTS_DIR)/analyze.sh $$log; \
	done

# 2. test: Run analyzer on each test_data file and verify expected output [cite: 1280]
# In a real workflow, this would compare results against a golden reference.
test: setup
	@echo "Verifying analyzer output for test_data..."
	./$(SCRIPTS_DIR)/analyze.sh $(LOG_DIR)/sample_pass.log
	./$(SCRIPTS_DIR)/analyze.sh $(LOG_DIR)/sample_fail.log || echo "Expected failure caught for sample_fail.log"

# 3. report: Generate a summary report in output/ [cite: 1280]
report: setup
	@echo "Generating summary report..."
	./$(SCRIPTS_DIR)/generate_report.sh

# 4. clean: Remove all generated output files [cite: 1281]
clean:
	@echo "Cleaning up generated output..."
	rm -rf $(OUTPUT_DIR)/*

# 5. help: Print all available targets with descriptions [cite: 1282]
help:
	@echo "riscv-log-analyzer Makefile Targets:"
	@echo "  all    : Run the analysis script on all available logs"
	@echo "  test   : Verify analyzer logic against sample logs"
	@echo "  report : Generate an aggregate summary in $(OUTPUT_DIR)/"
	@echo "  clean  : Remove all generated report files"
	@echo "  setup  : Validate that required tools are installed"
	@echo "  help   : Show this target list"

# 6. setup: Check that all required tools are installed [cite: 1283]
setup:
	@echo "Validating environment tools..."
	./$(SCRIPTS_DIR)/setup_env.sh