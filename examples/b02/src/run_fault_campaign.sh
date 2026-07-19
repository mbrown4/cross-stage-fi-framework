#!/bin/bash

#=========================================
# Fault Injection Campaign
#=========================================

DESIGN=${1:-b02}
MODE=${2:-rtl}

FAULTS=(
FI_U
FI_STATO_0
FI_STATO_1
FI_STATO_2
FI_STATO_3
FI_STATO_4
FI_STATO_5
FI_STATO_6
)

mkdir -p logs

echo "======================================"
echo "Running $MODE campaign for $DESIGN"
echo "======================================"

for FAULT in "${FAULTS[@]}"
do
    echo ""
    echo "--------------------------------------"
    echo "Injecting $FAULT"
    echo "--------------------------------------"

    make clean

    make $MODE DESIGN=$DESIGN INJECT_MASK=$FAULT \
        | tee logs/${DESIGN}_${MODE}_${FAULT}.log

done

echo ""
echo "Campaign complete."
