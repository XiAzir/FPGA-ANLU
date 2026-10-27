import ctypes
from ctypes import wintypes
import datetime
import json
from pathlib import Path
class Memory(ctypes.Structure):
    _fields_ = [('size', wintypes.DWORD), ('load', wintypes.DWORD)] + [
        (name, ctypes.c_ulonglong) for name in ('total', 'available', 'page_total', 'page_available', 'virtual_total', 'virtual_available', 'extended')]
m = Memory()
m.size = ctypes.sizeof(m)
assert ctypes.windll.kernel32.GlobalMemoryStatusEx(ctypes.byref(m))
value = {'recorded_at': datetime.datetime.now().astimezone().isoformat(),
         'memory_load_percent': m.load, 'available_GiB': round(m.available / 2**30, 3),
         'total_GiB': round(m.total / 2**30, 3)}
Path(__file__).with_name('host_resource_latest.json').write_text(json.dumps(value, indent=2), encoding='utf-8')
print(json.dumps(value))
