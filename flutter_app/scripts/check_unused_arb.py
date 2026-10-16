"""Reports ARB entries that no Dart source file references.

Run from `flutter_app/`:  python scripts/check_unused_arb.py

The brief requires "remove all unused ARB entries before submission", so this
is the check that proves it. A key counts as used when it appears either as a
quoted string (the `trKey('...')` style) or as a generated getter
(`l10n.someKey`).
"""

from __future__ import annotations

import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
ARB = ROOT / "lib" / "l10n" / "app_en.arb"
LIB = ROOT / "lib"


def main() -> int:
    arb = json.loads(ARB.read_text(encoding="utf-8"))
    keys = [key for key in arb if not key.startswith("@")]

    sources: list[str] = []
    for path in LIB.rglob("*.dart"):
        parts = path.parts
        if "l10n" in parts and "generated" in parts:
            continue  # the generated getters reference every key
        sources.append(path.read_text(encoding="utf-8"))
    blob = "\n".join(sources)

    unused = [
        key
        for key in keys
        if not (
            re.search(r"['\"]" + re.escape(key) + r"['\"]", blob)
            or re.search(r"\." + re.escape(key) + r"\b", blob)
        )
    ]

    print(f"ARB keys      : {len(keys)}")
    print(f"referenced    : {len(keys) - len(unused)}")
    print(f"unused        : {len(unused)}")

    if unused:
        print("\nUnused entries:")
        for key in unused:
            print(f"  - {key}")
        return 1

    print("\nNo unused ARB entries.")
    return 0


if __name__ == "__main__":
    sys.exit(main())