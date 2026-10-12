#!/usr/bin/env python3
"""Read-only checks for the FPGA-ANLU development checkout."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any


REPO = Path(__file__).resolve().parents[1]
C11206 = REPO / "development/player_bmp_scale"
C11206_CHECKPOINT = C11206 / "checkpoints/bmp_scale_20261012_verified"
C11206_MANIFEST = C11206_CHECKPOINT / "manifest.json"
ACCEPTANCE = C11206 / "build/acceptance_verified.json"
PARENT_AUDIT = C11206_CHECKPOINT / "build/model/parent_source_audit.json"
PARENT_CHECKPOINT = REPO / "development/player_transition_wipe/checkpoints/transition_wipe_20261012_verified"
MEDIA_MANIFEST = C11206_CHECKPOINT / "build/delivery/media_manifest.json"
MUSIC_AUDIT = REPO / "deliverables/real_music_20261008.package_audit.json"
CURRENT_STATE = Path("开发记录/当前状态.md")
FIVE_EXTENSIONS = Path("开发记录/专题记录/整机集成/C11206五扩展验收_20261012/README.md")


class Report:
    def __init__(self) -> None:
        self.items: list[dict[str, str]] = []

    def add(self, status: str, name: str, detail: str) -> None:
        self.items.append({"status": status, "name": name, "detail": detail})
        print(f"[{status}] {name}: {detail}")

    @property
    def failed(self) -> bool:
        return any(item["status"] == "FAIL" for item in self.items)


class NonFileManifest(ValueError):
    """A JSON record that is not a file inventory manifest."""


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest().upper()


def read_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8-sig") as stream:
        return json.load(stream)


def safe_manifest_path(root: Path, relative: str) -> Path:
    rel = Path(relative)
    if rel.is_absolute():
        raise ValueError(f"manifest contains an absolute path: {relative}")
    target = (root / rel).resolve()
    base = root.resolve()
    if target != base and base not in target.parents:
        raise ValueError(f"manifest path escapes its checkpoint: {relative}")
    return target


def manifest_entries(data: Any) -> list[dict[str, Any]]:
    if isinstance(data, list):
        entries = data
    elif isinstance(data, dict):
        lower_keys = {str(key).casefold(): key for key in data}
        files_key = lower_keys.get("files")
        entries_key = lower_keys.get("entries")
        if files_key is None and entries_key is None:
            raise NonFileManifest("JSON object has no Files or Entries inventory field")
        entries = data[files_key if files_key is not None else entries_key]
        if isinstance(entries, dict):
            entries = [{"path": name, **(value if isinstance(value, dict) else {"sha256": value})}
                       for name, value in entries.items()]
    else:
        raise ValueError("unsupported manifest structure")
    if not isinstance(entries, list):
        raise ValueError("manifest files/entries is not a list")
    if not entries:
        raise ValueError("file inventory is empty; refusing to treat an empty structure as a verified checkpoint")
    normalized = []
    for entry in entries:
        if not isinstance(entry, dict):
            raise ValueError("manifest entry is missing a path")
        fields = {str(key).casefold(): value for key, value in entry.items()}
        relative = fields.get("path", fields.get("name"))
        if not isinstance(relative, str):
            raise ValueError("manifest entry is missing a Path/Name field")
        normalized.append({
            "path": relative,
            "bytes": fields.get("bytes", fields.get("length", fields.get("size"))),
            "sha256": fields.get("sha256", fields.get("hash")),
            "sourceFields": list(entry.keys()),
        })
    return normalized


def verify_manifest(root: Path, manifest_path: Path, report: Report, label: str,
                    expected_hash: str | None = None, expected_count: int | None = None,
                    allow_non_file: bool = False) -> list[dict[str, Any]]:
    if not manifest_path.is_file():
        report.add("FAIL", label, f"缺少 manifest：{manifest_path}")
        return []
    actual_manifest_hash = sha256(manifest_path)
    if expected_hash and actual_manifest_hash != expected_hash.upper():
        report.add("FAIL", label, f"manifest SHA256 不匹配：{actual_manifest_hash}，期望 {expected_hash.upper()}")
        return []
    try:
        entries = manifest_entries(read_json(manifest_path))
    except NonFileManifest as exc:
        report.add("INFO" if allow_non_file else "FAIL", label,
                   f"明确分类为非文件清单，不计为 PASS：{exc}")
        return []
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        report.add("FAIL", label, f"无法解析 manifest：{exc}")
        return []
    if expected_count is not None and len(entries) != expected_count:
        report.add("FAIL", label, f"manifest 文件数为 {len(entries)}，期望 {expected_count}")
        return entries
    failures = []
    for entry in entries:
        rel = entry["path"]
        try:
            path = safe_manifest_path(root, rel)
        except ValueError as exc:
            failures.append(str(exc))
            continue
        if not path.is_file():
            failures.append(f"缺失 {rel}")
            continue
        expected_bytes = entry.get("bytes", entry.get("size"))
        if expected_bytes is not None and path.stat().st_size != int(expected_bytes):
            failures.append(f"大小不符 {rel}")
            continue
        expected_file_hash = entry.get("sha256", entry.get("hash"))
        if expected_file_hash and sha256(path) != str(expected_file_hash).upper():
            failures.append(f"SHA256 不符 {rel}")
    if failures:
        for failure in failures:
            report.add("FAIL", label, failure)
    else:
        report.add("PASS", label, f"{len(entries)} 项文件字节数/SHA256一致；manifest SHA256 {actual_manifest_hash}")
    return entries


def executable_version(command: list[str], pattern: str) -> tuple[bool, str]:
    try:
        result = subprocess.run(command, capture_output=True, text=True, timeout=15, check=False)
    except (OSError, subprocess.TimeoutExpired) as exc:
        return False, str(exc)
    text = (result.stdout + "\n" + result.stderr).strip()
    match = re.search(pattern, text, re.IGNORECASE)
    if result.returncode != 0 or not match:
        return False, text or f"exit code {result.returncode}"
    return True, match.group(1)


def resolve_iverilog_bin(repo: Path) -> Path | None:
    configured = os.environ.get("ANLU_IVERILOG_BIN")
    candidates: list[Path] = []
    if configured:
        value = Path(configured).expanduser()
        if not value.is_absolute() or not value.is_dir():
            return None
        candidates.append(value)
        for candidate in candidates:
            if (candidate / "iverilog.exe").is_file() and (candidate / "vvp.exe").is_file():
                return candidate.resolve()
            if (candidate / "iverilog").is_file() and (candidate / "vvp").is_file():
                return candidate.resolve()
        return None
    path_iverilog = shutil.which("iverilog.exe") or shutil.which("iverilog")
    if path_iverilog:
        return Path(path_iverilog).resolve().parent
    candidates.append(repo / "bringup/tf_wav_hdmi/tools/iverilog/app/bin")
    for candidate in candidates:
        if (candidate / "iverilog.exe").is_file() and (candidate / "vvp.exe").is_file():
            return candidate.resolve()
        if (candidate / "iverilog").is_file() and (candidate / "vvp").is_file():
            return candidate.resolve()
    return None


def resolve_td() -> Path | None:
    configured = os.environ.get("ANLU_TD_BIN")
    if configured:
        value = Path(configured).expanduser()
        if not value.is_absolute() or not value.is_dir():
            return None
        wrapper = value / "td_commands_prompt.exe"
        return wrapper.resolve() if wrapper.is_file() else None
    on_path = shutil.which("td_commands_prompt.exe")
    if on_path:
        return Path(on_path).resolve()
    fallback = Path("C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/bin/td_commands_prompt.exe")
    return fallback.resolve() if fallback.is_file() else None


def resolve_python_command() -> list[str] | None:
    configured = os.environ.get("ANLU_PYTHON")
    if configured:
        executable = Path(configured).expanduser()
        if not executable.is_absolute() or not executable.is_file():
            return None
    else:
        found = next((value for name in ("python.exe", "python", "py.exe", "py")
                      if (value := shutil.which(name))), None)
        if not found:
            return None
        executable = Path(found)
    command = [str(executable.resolve())]
    if executable.stem.lower() == "py":
        command.append("-3")
    return command


def check_tools(repo: Path, report: Report) -> None:
    pwsh = shutil.which("pwsh")
    if not pwsh:
        report.add("FAIL", "PowerShell 7", "找不到 pwsh；安装 PowerShell 7 并加入 PATH。")
    else:
        ok, version = executable_version([pwsh, "-NoLogo", "-NoProfile", "-Command", "$PSVersionTable.PSVersion.Major"], r"\b(\d+)\b")
        if not ok or int(version) < 7:
            report.add("FAIL", "PowerShell 7", f"pwsh 不可用或版本低于 7：{version}")
        else:
            report.add("PASS", "PowerShell 7", f"major version {version}")

    git = shutil.which("git")
    if git:
        ok, version = executable_version([git, "--version"], r"git version\s+([0-9][^\s]*)")
        report.add("PASS" if ok else "FAIL", "Git", version if ok else f"无法确认版本：{version}")
    else:
        report.add("FAIL", "Git", "找不到 git；安装 Git for Windows 并加入 PATH。")

    python_command = resolve_python_command()
    ok, version = executable_version(python_command + ["--version"], r"Python\s+([0-9]+\.[0-9]+(?:\.[0-9]+)?)") if python_command else (False, "解释器缺失或 ANLU_PYTHON 不是有效的绝对路径")
    if not ok or tuple(int(part) for part in version.split(".")[:2]) < (3, 9):
        report.add("FAIL", "Python", f"需要 Python 3.9+；当前 {version or '不可用'}。可设置 ANLU_PYTHON。")
    else:
        report.add("PASS", "Python", f"{version} ({' '.join(python_command)})")

    try:
        provenance = read_json(repo / "bringup/tf_wav_hdmi/tools/provenance.json")
        expected = re.search(r"[0-9]+\.[0-9]+", str(provenance.get("IcarusVersion", "")))
        expected_version = expected.group(0) if expected else "12.0"
    except (OSError, ValueError, json.JSONDecodeError):
        expected_version = "12.0"
    bin_dir = resolve_iverilog_bin(repo)
    if not bin_dir:
        report.add("FAIL", "Icarus Verilog", "找不到 iverilog.exe 与 vvp.exe；运行 scripts/setup_iverilog.ps1，或设置 ANLU_IVERILOG_BIN。")
    else:
        good = True
        for name in ("iverilog", "vvp"):
            exe = bin_dir / (name + (".exe" if os.name == "nt" else ""))
            ok, version = executable_version([str(exe), "-V"], r"Icarus Verilog(?: runtime)? version\s+([0-9]+\.[0-9]+)")
            if not ok or version != expected_version:
                good = False
                report.add("FAIL", name, f"需要 Icarus {expected_version}；{exe} 检测到 {version or '不可用'}。")
            else:
                report.add("PASS", name, f"Icarus {version} ({exe})")
        if good:
            report.add("PASS", "ANLU_IVERILOG_BIN", str(bin_dir))

    td = resolve_td()
    if td:
        report.add("PASS", "Tang Dynasty command wrapper", f"找到 td_commands_prompt.exe：{td}；检查器未启动工具。")
    else:
        report.add("FAIL", "Tang Dynasty command wrapper",
                   "找不到 td_commands_prompt.exe；将其所在绝对 bin 目录设为 ANLU_TD_BIN，或加入 PATH。")


def inspect_checkpoint_omissions(repo: Path, report: Report) -> None:
    checkpoints = sorted(repo.glob("development/**/checkpoints/**/manifest.json"))
    referenced = 0
    absent_references = 0
    unmanifested = 0
    summaries = []
    for manifest_path in checkpoints:
        root = manifest_path.parent
        try:
            entries = manifest_entries(read_json(manifest_path))
        except NonFileManifest as exc:
            report.add("INFO", str(manifest_path.relative_to(repo)),
                       f"非文件清单，单独分类、不计为 PASS：{exc}")
            continue
        except (OSError, ValueError, json.JSONDecodeError) as exc:
            report.add("FAIL", str(manifest_path.relative_to(repo)), f"无法解析 checkpoint manifest：{exc}")
            continue
        listed = {str(item["path"]).replace("\\", "/").casefold() for item in entries}
        refs = [item["path"] for item in entries if str(item["path"]).lower().endswith((".db", ".vvp"))]
        missing_refs = []
        for rel in refs:
            referenced += 1
            try:
                if not safe_manifest_path(root, rel).is_file():
                    absent_references += 1
                    missing_refs.append(rel)
            except ValueError:
                absent_references += 1
                missing_refs.append(rel)
        hidden_files = []
        for path in root.rglob("*"):
            if not path.is_file() or path.suffix.lower() not in (".db", ".vvp"):
                continue
            rel = path.relative_to(root).as_posix()
            if rel.casefold() not in listed:
                unmanifested += 1
                hidden_files.append(rel)
        if refs or hidden_files:
            summaries.append((manifest_path, refs, missing_refs, hidden_files))
    report.add("INFO", "checkpoint .db/.vvp 遮蔽盘点",
               f"检查 {len(checkpoints)} 个 manifest；明确引用 {referenced} 项，其中缺文件 {absent_references} 项；磁盘上存在但未列入 manifest 的忽略类文件 {unmanifested} 项。")
    for manifest_path, refs, missing_refs, hidden_files in summaries:
        details = []
        if refs:
            details.append(f"manifest 引用 {len(refs)} 项 .db/.vvp" + (f"，缺 {len(missing_refs)} 项" if missing_refs else ""))
        if hidden_files:
            details.append(f"manifest 未列出磁盘文件 {len(hidden_files)} 项")
        report.add("INFO", str(manifest_path.relative_to(repo)), "; ".join(details))
    if absent_references:
        report.add("FAIL", "checkpoint 忽略类引用", f"存在 {absent_references} 个 manifest 明确引用但磁盘缺失的 .db/.vvp 文件。")


def check_current_files(repo: Path, docs_root: Path, report: Report, all_checkpoints: bool) -> None:
    try:
        acceptance = read_json(repo / ACCEPTANCE.relative_to(REPO))
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        report.add("FAIL", "C11206 acceptance_verified", f"缺失或无法解析：{exc}")
        acceptance = {}
    expected_manifest_hash = str(acceptance.get("manifestSha256", ""))
    expected_count = int(acceptance.get("manifestFiles", 0)) if acceptance else 0
    entries = verify_manifest(C11206_CHECKPOINT, C11206_MANIFEST, report, "C11206 verified checkpoint",
                              expected_hash=expected_manifest_hash or None,
                              expected_count=expected_count or None)
    if acceptance:
        if acceptance.get("version") != "C11206" or not acceptance.get("sourceAndBitUnchanged"):
            report.add("FAIL", "C11206 acceptance_verified", "版本或 sourceAndBitUnchanged 字段与预期不符。")
        else:
            report.add("PASS", "C11206 acceptance_verified", "版本为 C11206，封存状态凭据存在。")
        expected_bit = str(acceptance.get("bitSha256", "")).upper()
        bit_path = repo / "download/bmp_scale.bit"
        if not bit_path.is_file():
            report.add("FAIL", "C11206 live bit", f"缺少 {bit_path}")
        elif sha256(bit_path) != expected_bit:
            report.add("FAIL", "C11206 live bit", f"SHA256 {sha256(bit_path)} 与 acceptance_verified 不符。")
        else:
            report.add("PASS", "C11206 live bit", f"SHA256 {expected_bit} 与 acceptance_verified 一致。")
        try:
            receipt = read_json(docs_root / "开发记录/专题记录/图片缩放/多尺寸最近邻首版_20261012/verified_receipt.json")
            if (receipt.get("manifestSha256", "").upper() != expected_manifest_hash.upper()
                    or receipt.get("bitSha256", "").upper() != expected_bit
                    or int(receipt.get("manifestFiles", 0)) != expected_count):
                report.add("FAIL", "C11206 docs receipt", "资料仓 verified_receipt 与工程 acceptance_verified 的 manifest/bit 信息不匹配。")
            else:
                report.add("PASS", "C11206 docs receipt", "资料仓 verified_receipt 与工程 acceptance_verified 匹配。")
        except (OSError, ValueError, json.JSONDecodeError) as exc:
            report.add("FAIL", "C11206 docs receipt", f"缺失或无法解析：{exc}")

    # The parent manifest hash is part of C11206's inherited-source audit, so it is a required provenance link.
    try:
        parent_audit = read_json(repo / PARENT_AUDIT.relative_to(REPO))
        parent_hash = str(parent_audit["parentManifestSha256"])
        parent_count = int(parent_audit["parentFrozenFiles"])
        verify_manifest(PARENT_CHECKPOINT, PARENT_CHECKPOINT / "manifest.json", report,
                        "C11205 parent verified checkpoint", expected_hash=parent_hash,
                        expected_count=parent_count)
    except (OSError, KeyError, ValueError, json.JSONDecodeError) as exc:
        report.add("FAIL", "C11205 parent verified checkpoint", f"无法取得继承凭据：{exc}")

    try:
        media = read_json(repo / MEDIA_MANIFEST.relative_to(REPO))
        assets = media.get("files", [])
        if len(assets) != 4:
            report.add("FAIL", "C11206 TF BMP media", f"media_manifest 中应有 4 张 BMP，实际 {len(assets)} 张。")
        for asset in assets:
            name = asset.get("tfName")
            path = C11206_CHECKPOINT / "build/delivery/TF_ROOT" / str(name)
            expected = str(asset.get("sha256", "")).upper()
            if not path.is_file():
                report.add("FAIL", f"TF {name}", f"缺少封存素材：{path}")
            elif sha256(path) != expected:
                report.add("FAIL", f"TF {name}", f"SHA256 {sha256(path)} 与 media_manifest 不符。")
            else:
                report.add("PASS", f"TF {name}", f"SHA256 与 media_manifest 一致（{path.stat().st_size} bytes）。")
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        report.add("FAIL", "C11206 TF BMP media", f"media_manifest 缺失或无法解析：{exc}")

    try:
        audit = read_json(repo / MUSIC_AUDIT.relative_to(REPO))
        package_hash = str(audit["manifest"]["card/TEST.WAV"]).upper()
        music_reference = read_json(C11206_CHECKPOINT / "build/model/music_reference.json")
        if str(music_reference.get("sourceSha256", "")).upper() != package_hash:
            report.add("FAIL", "C11206 TEST.WAV source reference", "工程 music_reference 与 real_music package audit 的 TEST.WAV SHA256 不一致。")
        else:
            report.add("PASS", "C11206 TEST.WAV source reference", f"参考 SHA256 {package_hash} 与 real_music package audit 一致。")
        delivered_wav = repo / "deliverables/real_music_20261008/card/TEST.WAV"
        if not delivered_wav.is_file():
            report.add("FAIL", "60秒音乐 TEST.WAV", f"缺少素材：{delivered_wav}")
        elif sha256(delivered_wav) != package_hash:
            report.add("FAIL", "60秒音乐 TEST.WAV", f"SHA256 {sha256(delivered_wav)} 与 real_music package audit 不符。")
        else:
            report.add("PASS", "60秒音乐 TEST.WAV", f"SHA256 与 real_music package audit 一致：{delivered_wav.relative_to(repo)}")
    except (OSError, KeyError, ValueError, json.JSONDecodeError) as exc:
        report.add("FAIL", "TEST.WAV reference", f"无法读取 real_music package audit 或 music_reference：{exc}")

    # The old bring-up image uses a separate 8-second tone fixture.
    try:
        tone_record = read_json(repo / "bringup/tf_wav_hdmi/build/card_wav_verification.json")
        bit_info = read_json(repo / "bringup/tf_wav_hdmi/build/manual/bitstream_info.json")
        tone_hash = str(tone_record["SHA256"]).upper()
        if str(bit_info.get("WAV_SHA256", "")).upper() != tone_hash:
            report.add("FAIL", "8秒音阶 TEST.WAV provenance", "card_wav_verification 与 bitstream_info 哈希不匹配。")
        else:
            report.add("PASS", "8秒音阶 TEST.WAV provenance", f"历史记录一致，参考 SHA256 {tone_hash}。")
        tone_path = repo / "bringup/tf_wav_hdmi/card_media/TEST.WAV"
        if not tone_path.is_file():
            report.add("FAIL", "8秒音阶 TEST.WAV", f"缺少原音阶素材：{tone_path}")
        elif sha256(tone_path) != tone_hash:
            report.add("FAIL", "8秒音阶 TEST.WAV", f"SHA256 {sha256(tone_path)} 与其历史 card_wav_verification 不符。")
        else:
            report.add("PASS", "8秒音阶 TEST.WAV", f"SHA256 与自己的历史验证记录一致：{tone_path.relative_to(repo)}")
    except (OSError, KeyError, ValueError, json.JSONDecodeError) as exc:
        report.add("FAIL", "8秒音阶 TEST.WAV provenance", f"无法读取历史参考：{exc}")

    for path, label in ((docs_root / CURRENT_STATE, "资料仓当前状态"),
                        (docs_root / FIVE_EXTENSIONS, "C11206五扩展验收资料")):
        if path.is_file():
            report.add("PASS", label, str(path))
        else:
            report.add("FAIL", label, f"缺少资料文件：{path}；可用 --docs-root 指定资料仓目录。")

    inspect_checkpoint_omissions(repo, report)
    if all_checkpoints:
        manifests = sorted(repo.glob("development/**/checkpoints/**/manifest.json"))
        total = 0
        for manifest in manifests:
            total += 1
            verify_manifest(manifest.parent, manifest, report,
                            f"历史 checkpoint {manifest.parent.relative_to(repo)}", allow_non_file=True)
        report.add("INFO", "全历史 checkpoint 校验", f"已检查 {total} 个 manifest 的全部文件。")


def main() -> int:
    for stream_name in ("stdout", "stderr"):
        stream = getattr(sys, stream_name, None)
        if hasattr(stream, "reconfigure"):
            stream.reconfigure(encoding="utf-8", errors="replace")
    parser = argparse.ArgumentParser(description="只读检查 FPGA-ANLU 接续所需工程、资料与工具。")
    parser.add_argument("--docs-root", type=Path,
                        help="资料仓目录；默认使用同级 FPGA-ANLU-docs。个人资料目录请显式指定。")
    parser.add_argument("--files-only", action="store_true", help="跳过 pwsh/git/python/Icarus/TD 工具检查。")
    parser.add_argument("--all-checkpoints", action="store_true", help="校验所有历史 checkpoint manifest 中的每个文件。")
    parser.add_argument("--json", dest="json_path", type=Path, help="同时写入指定路径的 JSON 摘要；不记录环境变量值。")
    args = parser.parse_args()

    docs_root = (args.docs_root.expanduser().resolve() if args.docs_root
                 else (REPO.parent / "FPGA-ANLU-docs").resolve())
    report = Report()
    print(f"工程仓：{REPO}")
    print(f"资料仓：{docs_root}")
    if not args.files_only:
        check_tools(REPO, report)
    check_current_files(REPO, docs_root, report, args.all_checkpoints)
    result = {"repo": str(REPO), "docs_root": str(docs_root), "failed": report.failed,
              "results": report.items}
    if args.json_path:
        output_path = args.json_path.expanduser().resolve()
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(f"JSON 报告：{output_path}")
    failures = sum(item["status"] == "FAIL" for item in report.items)
    print(f"结果：{failures} 项缺失或不匹配。" if failures else "结果：必需项完整；请根据 INFO 项查看历史忽略产物。")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
