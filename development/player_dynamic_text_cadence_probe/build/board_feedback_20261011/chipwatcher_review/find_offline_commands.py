from pathlib import Path
import sys
from pypdf import PdfReader
sys.stdout.reconfigure(encoding='utf-8')
root=Path('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/doc')
for name in ['SWUG/SWUG105_TCL_Command_User_Guide.pdf','TD_User_Guide_V6.2.pdf']:
    reader=PdfReader(root/name)
    for index,page in enumerate(reader.pages):
        value=page.extract_text() or ''
        if any(x in value.lower() for x in ['chipprobe','compile_probe','config_chipwatcher','insert_debugger','compile_watcher']):
            print(f'FILE {name} PDF PAGE {index+1}\n{value}\n')
