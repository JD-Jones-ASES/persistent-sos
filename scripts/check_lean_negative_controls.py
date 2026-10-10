#!/usr/bin/env python3
"""Require Lean to reject actual perturbations of an exact PSD certificate.

The unchanged small block is compiled first. Each negative control changes
one matrix entry; rejection must occur at a proof of a Schur identity or a
strictly positive pivot, never from an import, parsing, or process failure.
"""
from __future__ import annotations
import json
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'PersistentSOS' / 'MomentBlock1.lean'


def require(condition, message):
    if not condition:
        raise ValueError(message)


def perturb(source, stage, transform):
    pattern = rf'(def momentBlock1Stage{stage} :[^\n]+\n\s*!\[!\[)(-?\d+)'
    match = re.search(pattern, source)
    require(match is not None, 'certificate entry not found')
    value = int(match.group(2))
    return source[:match.start(2)] + str(transform(value)) + source[match.end(2):]


def compile_source(directory, name, text):
    path = directory / (name + '.lean')
    path.write_text(text)
    result = subprocess.run(['lake', 'env', 'lean', str(path)], cwd=ROOT,
                            text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                            timeout=180, check=False)
    return result.returncode, result.stdout


def main():
    source = SOURCE.read_text()
    with tempfile.TemporaryDirectory(prefix='persistent-sos-lean-controls-') as raw_directory:
        directory = Path(raw_directory)
        code, output = compile_source(directory, 'UnchangedBlock', source)
        require(code == 0, 'unchanged certificate failed:\n' + output)
        reports = []
        for name, changed in [
            ('ChangedMomentEntry', perturb(source, 0, lambda n: n + 1)),
            ('NegativeFinalPivot', perturb(source, 10, lambda n: -abs(n))),
        ]:
            code, output = compile_source(directory, name, changed)
            require(code != 0, name + ' was unexpectedly accepted')
            require('error:' in output and 'decide' in output,
                    name + ' failed outside an arithmetic proof:\n' + output)
            require(not any(s in output for s in ['unknown module', 'Unknown module',
                'unexpected token', 'failed to synthesize', 'no such file', 'maximum recursion',
                'maximum number of steps', 'maximum heartbeats']),
                name + ' encountered an environmental or elaboration failure:\n' + output)
            reports.append({'control': name, 'status': 'KERNEL_REJECTED'})
    print(json.dumps({'unchanged_block': 'PASS', 'negative_controls': reports}, indent=2))


if __name__ == '__main__':
    main()
