#!/usr/bin/env python3
import os
from pathlib import Path
import subprocess
import textwrap

ROOT = Path(__file__).resolve().parent
SRC_ROOT = ROOT / "src"
OUTPUT_DIR = ROOT / "dist"
INPUT_FILE = SRC_ROOT / "init.lua"
OUTPUT_FILE = OUTPUT_DIR / "library.lua"
DARKLUA_CONFIG = ROOT / "darklua.json"

MODULE_START = "-- MODULES_START"
MODULE_END = "-- MODULES_END"


def module_name(path: Path) -> str:
    rel = path.relative_to(SRC_ROOT).with_suffix("")
    return ".".join(rel.parts)


def read_module(path: Path) -> str:
    text = path.read_text(encoding="utf-8")
    stripped = text.lstrip()
    if stripped.startswith("return function(require)"):
        prefix_len = text.find("return function(require)")
        return text[prefix_len + len("return "):]
    return text


def collect_modules() -> str:
    modules = []
    allowed_roots = {"Core", "Components", "Effects", "Services"}
    for path in sorted(SRC_ROOT.rglob("*.lua")):
        if path == INPUT_FILE:
            continue

        rel = path.relative_to(SRC_ROOT)
        if rel.parts[0] not in allowed_roots:
            continue

        module_id = module_name(path)
        body = read_module(path).rstrip()
        stripped = body.lstrip()
        if not stripped.startswith("function(require)"):
            continue

        modules.append(f"internalModules[{module_id!r}] = {body}\n")
    return "\n".join(modules)


def build():
    if not INPUT_FILE.exists():
        raise FileNotFoundError(f"Entry point not found: {INPUT_FILE}")

    text = INPUT_FILE.read_text(encoding="utf-8")
    if MODULE_START not in text or MODULE_END not in text:
        raise RuntimeError("init.lua must contain MODULES_START and MODULES_END placeholders")

    modules_text = collect_modules()
    output_text = text.replace(f"{MODULE_START}\n{MODULE_END}", f"{MODULE_START}\n{modules_text}\n{MODULE_END}")

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    OUTPUT_FILE.write_text(output_text, encoding="utf-8")
    print(f"Bundled library written to {OUTPUT_FILE}")

    if shutil.which("darklua"):
        subprocess.run(["darklua", "process", str(OUTPUT_FILE), str(OUTPUT_FILE), "--format", "readable"], check=True)
        print("Formatted library with Darklua")


if __name__ == "__main__":
    import shutil
    build()
