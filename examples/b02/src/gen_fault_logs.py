#!/usr/bin/env python3

import argparse
import csv
import re
import sys
from pathlib import Path
from typing import Any


RTL_CYCLE_PATTERN = re.compile(
    r"CYCLE=(?P<cycle>\d+)\s*\|\s*"
    r"rst=(?P<reset>[01xXzZ])\s+"
    r"linea=(?P<linea>[01xXzZ])\s+"
    r"fe=(?P<fault_enable>[01xXzZ]+)\s*\|\s*"
    r"G:u=(?P<golden_u>[01xXzZ])\s+"
    r"F:u=(?P<faulty_u>[01xXzZ])\s+"
    r"G:st=(?P<golden_state>[0-9xXzZ]+)\s+"
    r"F:st=(?P<faulty_state>[0-9xXzZ]+)"
)

GL_CYCLE_PATTERN = re.compile(
    r"CYCLE=(?P<cycle>\d+)\s*\|\s*"
    r"rst=(?P<reset>[01xXzZ])\s+"
    r"linea=(?P<linea>[01xXzZ])\s+"
    r"fe=(?P<fault_enable>[01xXzZ]+)\s*\|\s*"
    r"G:u=(?P<golden_u>[01xXzZ])\s+"
    r"F:u=(?P<faulty_u>[01xXzZ])\s+"
    r"G:st_dec=(?P<golden_state>[0-9xXzZ]+)\s+"
    r"F:st_dec=(?P<faulty_state>[0-9xXzZ]+)\s+"
    r"G:raw=(?P<golden_raw>[01xXzZ]+)\s+"
    r"F:raw=(?P<faulty_raw>[01xXzZ]+)"
)

INJECT_CYCLE_PATTERN = re.compile(r"INJECT_CYCLE=(\d+)")
INJECT_MASK_PATTERN = re.compile(r"INJECT_MASK=([01xXzZ]+)")
FIRST_MISMATCH_PATTERN = re.compile(
    r"FIRST MISMATCH at cycle\s+(\d+)"
)


def parse_log_name(log_path: Path) -> tuple[str, str, str]:
    """
    Expected filename format:

        b02_rtl_FI_STATO_0.log
        b02_gl_FI_U.log

    Returns:
        design, mode, fault_name
    """

    stem = log_path.stem

    match = re.match(
        r"(?P<design>.+?)_(?P<mode>rtl|gl)_(?P<fault>FI_.+)",
        stem,
        re.IGNORECASE,
    )

    if not match:
        return "unknown", "unknown", stem

    return (
        match.group("design"),
        match.group("mode").lower(),
        match.group("fault"),
    )


def signal_differs(golden: str, faulty: str) -> int:
    """
    Uses string comparison so X and Z values remain visible.
    """

    return int(golden.lower() != faulty.lower())


def parse_log(log_path: Path) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    text = log_path.read_text(encoding="utf-8", errors="replace")

    design, mode, fault_name = parse_log_name(log_path)

    inject_cycle_match = INJECT_CYCLE_PATTERN.search(text)
    inject_mask_match = INJECT_MASK_PATTERN.search(text)
    first_mismatch_match = FIRST_MISMATCH_PATTERN.search(text)

    inject_cycle = (
        int(inject_cycle_match.group(1))
        if inject_cycle_match
        else -1
    )

    inject_mask = (
        inject_mask_match.group(1)
        if inject_mask_match
        else "NA"
    )

    first_mismatch_cycle = (
        int(first_mismatch_match.group(1))
        if first_mismatch_match
        else -1
    )

    cycle_rows: list[dict[str, Any]] = []

    # Select the appropriate cycle format based on the log filename.
    if mode == "gl":
        cycle_matches = GL_CYCLE_PATTERN.finditer(text)
    else:
        cycle_matches = RTL_CYCLE_PATTERN.finditer(text)

    for match in cycle_matches:
        cycle = int(match.group("cycle"))
        reset = match.group("reset")
        linea = match.group("linea")
        fault_enable = match.group("fault_enable")
        golden_u = match.group("golden_u")
        faulty_u = match.group("faulty_u")
        golden_state = match.group("golden_state")
        faulty_state = match.group("faulty_state")

        if mode == "gl":
            golden_raw = match.group("golden_raw")
            faulty_raw = match.group("faulty_raw")
        else:
            golden_raw = ""
            faulty_raw = ""

        output_mismatch = signal_differs(
            golden_u,
            faulty_u,
        )

        state_mismatch = signal_differs(
            golden_state,
            faulty_state,
        )

        if mode == "gl":
            raw_state_mismatch = signal_differs(
                golden_raw,
                faulty_raw,
            )
        else:
            raw_state_mismatch = state_mismatch

        any_mismatch = int(
            output_mismatch
            or state_mismatch
            or raw_state_mismatch
        )

        fault_active = int(
            any(char == "1" for char in fault_enable)
        )

        cycle_rows.append(
            {
                "design": design,
                "mode": mode,
                "fault_name": fault_name,
                "cycle": cycle,
                "reset": reset,
                "linea": linea,
                "fault_enable": fault_enable,
                "fault_active": fault_active,
                "golden_u": golden_u,
                "faulty_u": faulty_u,
                "golden_state": golden_state,
                "faulty_state": faulty_state,
                "golden_raw_state": golden_raw,
                "faulty_raw_state": faulty_raw,
                "output_mismatch": output_mismatch,
                "state_mismatch": state_mismatch,
                "raw_state_mismatch": raw_state_mismatch,
                "any_mismatch": any_mismatch,
            }
        )

    mismatch_cycles = sum(
        row["any_mismatch"]
        for row in cycle_rows
    )

    output_mismatch_cycles = sum(
        row["output_mismatch"]
        for row in cycle_rows
    )

    state_mismatch_cycles = sum(
        row["state_mismatch"]
        for row in cycle_rows
    )

    raw_state_mismatch_cycles = sum(
        row["raw_state_mismatch"]
        for row in cycle_rows
    )

    mismatch_cycle_numbers = [
        row["cycle"]
        for row in cycle_rows
        if row["any_mismatch"]
    ]

    last_mismatch_cycle = (
        max(mismatch_cycle_numbers)
        if mismatch_cycle_numbers
        else -1
    )

    # Use the parsed cycle rows as a fallback when the explicit
    # FIRST MISMATCH message is absent.
    if first_mismatch_cycle < 0 and mismatch_cycle_numbers:
        first_mismatch_cycle = min(mismatch_cycle_numbers)

    propagation_latency = (
        first_mismatch_cycle - inject_cycle
        if first_mismatch_cycle >= 0
        and inject_cycle >= 0
        else -1
    )

    summary_row = {
        "design": design,
        "mode": mode,
        "fault_name": fault_name,
        "inject_cycle": inject_cycle,
        "inject_mask": inject_mask,
        "first_mismatch_cycle": first_mismatch_cycle,
        "last_mismatch_cycle": last_mismatch_cycle,
        "propagation_latency": propagation_latency,
        "observed_cycles": len(cycle_rows),
        "mismatch_cycles": mismatch_cycles,
        "output_mismatch_cycles": output_mismatch_cycles,
        "state_mismatch_cycles": state_mismatch_cycles,
        "raw_state_mismatch_cycles": raw_state_mismatch_cycles,
        "propagated": int(mismatch_cycles > 0),
        "log_file": str(log_path),
    }

    return cycle_rows, summary_row


def write_csv(
    output_path: Path,
    rows: list[dict[str, Any]],
) -> None:
    if not rows:
        return

    output_path.parent.mkdir(
        parents=True,
        exist_ok=True,
    )

    with output_path.open(
        "w",
        newline="",
        encoding="utf-8",
    ) as csv_file:
        writer = csv.DictWriter(
            csv_file,
            fieldnames=list(rows[0].keys()),
        )

        writer.writeheader()
        writer.writerows(rows)


def main() -> int:
    parser = argparse.ArgumentParser(
        description=(
            "Parse fault-injection simulation logs into "
            "cycle-level and campaign-summary CSV tables."
        )
    )

    parser.add_argument(
        "--logs",
        default="logs",
        help="Directory containing simulation .log files.",
    )

    parser.add_argument(
        "--output",
        default="results",
        help="Directory where CSV files will be written.",
    )

    args = parser.parse_args()

    logs_dir = Path(args.logs)
    output_dir = Path(args.output)

    if not logs_dir.exists():
        print(
            f"ERROR: Log directory does not exist: {logs_dir}",
            file=sys.stderr,
        )
        return 1

    log_files = sorted(logs_dir.glob("*.log"))

    if not log_files:
        print(
            f"ERROR: No .log files found in {logs_dir}",
            file=sys.stderr,
        )
        return 1

    cycle_output_dir = output_dir / "cycle_tables"
    summary_rows: list[dict[str, Any]] = []
    all_cycle_rows: list[dict[str, Any]] = []

    for log_path in log_files:
        cycle_rows, summary_row = parse_log(log_path)

        if not cycle_rows:
            print(
                f"WARNING: No cycle records found in {log_path}"
            )
            continue

        cycle_csv = (
            cycle_output_dir /
            f"{log_path.stem}_cycles.csv"
        )

        write_csv(cycle_csv, cycle_rows)

        summary_rows.append(summary_row)
        all_cycle_rows.extend(cycle_rows)

        print(
            f"Parsed {log_path.name}: "
            f"{len(cycle_rows)} cycles, "
            f"{summary_row['mismatch_cycles']} mismatches"
        )

    if not summary_rows:
        print(
            "ERROR: No valid logs were parsed.",
            file=sys.stderr,
        )
        return 1

    summary_csv = output_dir / "fault_campaign_summary.csv"
    combined_cycles_csv = (
        output_dir / "all_fault_cycles.csv"
    )

    write_csv(summary_csv, summary_rows)
    write_csv(combined_cycles_csv, all_cycle_rows)

    print()
    print(f"Summary table: {summary_csv}")
    print(f"Combined cycle table: {combined_cycles_csv}")
    print(f"Individual cycle tables: {cycle_output_dir}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())