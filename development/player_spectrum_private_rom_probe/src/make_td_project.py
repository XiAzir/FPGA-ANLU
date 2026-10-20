#!/usr/bin/env python3
"""Create a minimal TD synthesis-only project from the local AC201 template."""
from pathlib import Path
import sys
import xml.etree.ElementTree as ET

template = Path(sys.argv[1])
out = Path(sys.argv[2])
template_xml = template.read_text(encoding="utf-8").replace("P&R", "P&amp;R")
root = ET.fromstring(template_xml)
tree = ET.ElementTree(root)
root = tree.getroot()
root.set("Path", out.parent.as_posix())
root.find("Name").text = "spectrum_coeff_rom_probe"
sf = root.find("Source_Files")
for child in list(sf):
    sf.remove(child)
verilog = ET.SubElement(sf, "Verilog")
for idx, path in enumerate(("../top.v", "../spectrum_coeff_rom.v"), 1):
    file_node = ET.SubElement(verilog, "File", {"Path": path})
    info = ET.SubElement(file_node, "FileInfo")
    for name, value in (("UsedInSyn", "true"), ("UsedInP&R", "true"),
                        ("BelongTo", "design_1"), ("CompileOrder", str(idx))):
        ET.SubElement(info, "Attr", {"Name": name, "Val": value})
for tag in ("ADC_FILE", "SDC_FILE", "IP_FILE"):
    ET.SubElement(sf, tag)
top = root.find("TOP_MODULE")
top.find("LABEL").text = "top"
top.find("MODULE").text = "top"
for node in root.iter("eram_init"):
    node.text = "off"
out.parent.mkdir(parents=True, exist_ok=True)
tree.write(out, encoding="utf-8", xml_declaration=True)
print(out)
