"""Strips ARB entries that no Dart source file references.

Run from `flutter_app/`:  python scripts/prune_arb.py

The brief requires "remove all unused ARB entries before submission". Running
this keeps `app_en.arb` and `app_ar.parb` in lockstep: a key is removed from
both files together, so the two locales can never drift apart.
"""

from __future__ import annotations

import json
import pathlib
import re
import sys
from collections import OrderedDict

ROOT = pathlib.Path(__file__).resolve().parents[1]
ARB_FILES = {
    "en": ROOT / "lib" / "l10n" / "app_en.arb",
    "ar": ROOT / "lib" / "l10n" / "app_ar.arb",
}
LIB = ROOT / "lib"


def referenced_keys() -> set[str]:
    sources: list[str] = []
    for path in LIB.rglob("*.dart"):
        parts = path.parts
        if "l10n" in parts and "generated" in parts:
            continue  # generated getters reference every key by definition
        sources.append(path.read_text(encoding="utf-8"))
    blob = "\n".join(sources)

    used: set[str] = set()
    for path in LIB.rglob("*.dart"):
        if "l10n" not in path.parts:
            continue
    for key in _all_keys():
        if re.search(r"['\"]" + re.escape(key) + r"['\"]", blob) or re.search(
            r"\." + re.escape(key) + r"\b", blob
        ):
            used.add(key)
    return used


def _all_keys() -> list[str]:
    arb = json.loads(ARB_FILES["en"].read_text(encoding="utf-8"))
    return [key for key in arb if not key.startswith("@")]


def prune(path: pathlib.Path, used: set[str]) -> list[str]:
    raw = path.read_text(encoding="utf-8")
    data = json.loads(raw, object_pairs_hook=OrderedDict)

    removed = [
        key
        for key in list(data.keys())
        if not key.startswith("@") and key not in used
    ]

    kept = OrderedDict(
        (key, value) for key, value in data.items()
        if key.startswith("@") or key in used or key not in removed
    )

    path.write_text(
        json.dumps(kept, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
    )
    return removed


def main() -> int:
    used = referenced_keys()
    removed_en = prune(ARB_FILES["en"], used)
    removed_ar = prune(ARB_FILES["ar"], used)

    if removed_en or removed_ar:
        print("Removed from app_en.arb:")
        for key in removed_en:
            print(f"  - {key}")
        if removed_ar:
            print("\nRemoved from app_ar.arb:")
            for key in removed_ar:
                print(f"  - {key}")
        print("\nRun `flutter gen-l10n` to regenerate AppLocalizations.")
        return 0

    print("Nothing to prune — every ARB entry is referenced.")
    return 0


if __name__ == "__main__":
    sys.exit(main())