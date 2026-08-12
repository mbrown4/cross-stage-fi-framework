#!/usr/bin/env bash

set -o pipefail

DESIGN=${1:-b05}
MODE=${2:-rtl}

TB_FILE="tb_${DESIGN}_fi.v"
LOG_DIR="logs"

if [[ ! -f "$TB_FILE" ]]; then
    echo "ERROR: Testbench not found: $TB_FILE"
    exit 1
fi

if [[ "$MODE" != "rtl" && "$MODE" != "gl" ]]; then
    echo "Usage: $0 <design> <rtl|gl>"
    exit 1
fi

mkdir -p "$LOG_DIR"

mapfile -t FAULTS < <(
    grep -oP \
        'localparam \[[^]]+\] \KFI_[A-Z0-9_]+' \
        "$TB_FILE" |
    grep -vE '^FI_(ALL_RTL_MAPPED|ALL_GL|NONE)$'
)

if [[ ${#FAULTS[@]} -eq 0 ]]; then
    echo "ERROR: No individual FI masks found in $TB_FILE"
    exit 1
fi

echo "======================================"
echo "Running $MODE campaign for $DESIGN"
echo "Testbench: $TB_FILE"
echo "Discovered targets: ${#FAULTS[@]}"
echo "======================================"

passed=0
failed=0
skipped=0

for FAULT in "${FAULTS[@]}"; do

    # The generated testbench marks synthesized-only targets in its
    # mapping comments. Skip those during RTL campaigns.
    if [[ "$MODE" == "rtl" ]]; then
        if grep -qE \
            "fault_en\[[0-9]+\].*${FAULT#FI_}.*GL_ONLY" \
            "$TB_FILE"; then
            echo
            echo "Skipping $FAULT: GL-only target"
            ((skipped++))
            continue
        fi
    fi

    echo
    echo "--------------------------------------"
    echo "Injecting $FAULT"
    echo "--------------------------------------"

    LOG_FILE="${LOG_DIR}/${DESIGN}_${MODE}_${FAULT}.log"

    make clean

    make "$MODE" \
        DESIGN="$DESIGN" \
        INJECT_MASK="$FAULT" \
        2>&1 | tee "$LOG_FILE"

    status=${PIPESTATUS[0]}

    if [[ $status -eq 0 ]]; then
        ((passed++))
    else
        echo "ERROR: $FAULT failed with status $status"
        ((failed++))
    fi
done

echo
echo "======================================"
echo "Campaign complete"
echo "Passed:  $passed"
echo "Failed:  $failed"
echo "Skipped: $skipped"
echo "======================================"

if [[ $failed -ne 0 ]]; then
    exit 1
fi