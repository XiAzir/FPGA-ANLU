"""Repository-relative locations and explicit guards for historical utilities."""
from pathlib import Path

REPOSITORY_ROOT = Path(__file__).resolve().parent.parent
DOCS_ROOT = REPOSITORY_ROOT.parent / 'FPGA-ANLU-docs'


def recorded_path(value):
    """Rebase recorded repository paths without altering the historical record."""
    normalized = str(value).replace('\\', '/')
    for original, current in (
        ('E:/VSCODE-project/FPGA-ANLU', REPOSITORY_ROOT),
        ('E:/QQ CACHE/Download/安路资料', DOCS_ROOT),
    ):
        if normalized.lower() == original.lower():
            return current
        if normalized.lower().startswith(original.lower() + '/'):
            return current / normalized[len(original) + 1:]
    path = Path(value)
    return path if path.is_absolute() else REPOSITORY_ROOT / path


def require_file(path):
    path = Path(path)
    if not path.is_file():
        raise FileNotFoundError(
            f'Required input is missing: {path}. Generated .db files are excluded '
            'from Git. Rebuild the corresponding project, or restore the exact '
            'original artifact required by its historical manifest. Integrity '
            'checks cannot be skipped.')
    return path
