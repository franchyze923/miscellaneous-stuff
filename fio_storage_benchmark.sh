#!/usr/bin/env bash
set -euo pipefail

if ! command -v fio >/dev/null 2>&1; then
  echo "ERROR: fio is not installed. Install it with: sudo apt install fio"
  exit 1
fi

LABEL="${1:-run1}"   # e.g. sata, nvme
OUTDIR="${2:-fio_results}"  # optional: custom output dir

mkdir -p "${OUTDIR}"
cd "${OUTDIR}"

echo "Running disk benchmarks with label: ${LABEL}"
echo "Results will be saved in: $(pwd)"
echo

TESTFILE="testfile_${LABEL}"
SIZE_SEQ="2G"
SIZE_RAND="1G"

# Helper to print a compact summary from fio output
print_summary () {
  local log="$1"
  echo "  → Summary:"
  # Grab the main read/write lines
  grep -E 'read:|write:' "$log" | sed 's/  */ /g' | sed 's/^/    /'
  echo
}

########################################
# Test A: Sequential write (1M blocks)
########################################
echo "===== [${LABEL}] Test A: Sequential WRITE (1M blocks, ${SIZE_SEQ}) ====="
fio --name="seqwrite_${LABEL}" \
    --filename="${TESTFILE}" \
    --size="${SIZE_SEQ}" \
    --bs=1M \
    --rw=write \
    --direct=1 \
    --iodepth=8 \
    --numjobs=1 \
    --time_based=0 \
    --group_reporting=1 \
    > "seqwrite_${LABEL}.log"
print_summary "seqwrite_${LABEL}.log"

########################################
# Test B: Sequential read (1M blocks)
########################################
echo "===== [${LABEL}] Test B: Sequential READ (1M blocks, ${SIZE_SEQ}) ====="
fio --name="seqread_${LABEL}" \
    --filename="${TESTFILE}" \
    --size="${SIZE_SEQ}" \
    --bs=1M \
    --rw=read \
    --direct=1 \
    --iodepth=8 \
    --numjobs=1 \
    --time_based=0 \
    --group_reporting=1 \
    > "seqread_${LABEL}.log"
print_summary "seqread_${LABEL}.log"

########################################
# Test C: Random 4K read/write (50/50)
########################################
echo "===== [${LABEL}] Test C: Random 4K READ/WRITE (1G, QD32, 4 jobs) ====="
fio --name="randrw_${LABEL}" \
    --filename="${TESTFILE}" \
    --size="${SIZE_RAND}" \
    --bs=4k \
    --rw=randrw \
    --rwmixread=50 \
    --direct=1 \
    --iodepth=32 \
    --numjobs=4 \
    --time_based=0 \
    --group_reporting=1 \
    > "randrw_${LABEL}.log"
print_summary "randrw_${LABEL}.log"

echo "All tests for label '${LABEL}' complete."
echo "Logs:"
ls -1 *.log

echo
echo "You can now run this script again with a different label (e.g. 'nvme') and compare summaries."
