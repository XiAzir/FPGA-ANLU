from __future__ import annotations

import difflib
from pathlib import Path

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[2]
target = "development/player_spectrum_resource_80/src/user_source/hdl_source/top_tf_hdmi_audio.v"
before = (ROOT / "base_top_tf_hdmi_audio.v").read_text(encoding="utf-8-sig").splitlines(keepends=True)
after = (ROOT / "top_tf_hdmi_audio.v").read_text(encoding="utf-8-sig").splitlines(keepends=True)
lines = [f"diff --git a/{target} b/{target}\n"]
lines.extend(difflib.unified_diff(before, after, fromfile=f"a/{target}", tofile=f"b/{target}"))
(ROOT / "top_parameter_specialization.patch").write_text("".join(lines), encoding="utf-8")
