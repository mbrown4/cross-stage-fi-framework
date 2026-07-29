#!/bin/bash

#=========================================
# Fault Injection Campaign
#=========================================

DESIGN=${1:-b03}
MODE=${2:-rtl}

FAULTS=(
FI_STATO_0
FI_STATO_1
FI_STATO_2
FI_GRANT_O_0
FI_GRANT_O_1
FI_GRANT_O_2
FI_GRANT_O_3
FI_CODA0_0
FI_CODA0_1
FI_CODA0_2
FI_CODA1_0
FI_CODA1_1
FI_CODA1_2
FI_CODA2_0
FI_CODA2_1
FI_CODA2_2
FI_GRANT_0
FI_GRANT_1
FI_GRANT_2
FI_GRANT_3
FI_CODA3_0
FI_CODA3_1
FI_CODA3_2
FI_RU1_0
FI_RU2_0
FI_RU3_0
FI_RU4_0
FI_FU1_0
FI_FU2_0
FI_FU3_0
FI_FU4_0
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
