"""State invariants eliminate duplicated mapper counters and unreachable width."""
from pathlib import Path
import re

def apply(path, *, counters=True, cluster_width=True, subtract=True, mask=True):
    p=Path(path);s=p.read_text(encoding='utf-8-sig')
    if counters:
        s=s.replace('    reg [12:0] walk_count, cache_walk_count;',
                    "    wire [12:0] walk_count = {1'b0, walk_index};\n    wire [12:0] cache_walk_count = {1'b0, cache_index};")
        s=re.sub(r'^\s*(?:walk_count|cache_walk_count) <= [^;]+;\n','\n',s,flags=re.M)
        # A successful CHECK fixes target<=4095 and walk_index starts<=target.
        s=s.replace('                end else if (walk_count >= 4096) begin\n                    fail(E_LIMIT);\n                end else begin',
                    '                end else begin')
    if cluster_width:
        for before,after in [
            ('reg [31:0] current_cluster;', 'reg [27:0] current_cluster;'),
            ('reg [31:0] cache_cluster, cache_start, cache_size;', 'reg [27:0] cache_cluster, cache_start;\n    reg [31:0] cache_size;'),
            ('reg [31:0] brent_anchor, cache_brent_anchor;', 'reg [27:0] brent_anchor, cache_brent_anchor;'),
            ('reg [13:0] brent_power, cache_brent_power;', 'reg [12:0] brent_power, cache_brent_power;'),
            ('reg [10:0] byte_count;', 'reg [9:0] byte_count;'),
            ("{8'd0, current_cluster[31:7]}","{12'd0, current_cluster[27:7]}")]:
            assert before in s,before;s=s.replace(before,after)
    if subtract:
        before="(({16'd0, current_cluster[27:0]} - 44'd2) <<"
        after="({16'd0, (current_cluster[27:0] - 28'd2)} <<"
        assert before in s;s=s.replace(before,after)
    if mask:
        s=s.replace('    reg [3:0] got_mask;\n','')
        s=re.sub(r'^\s*got_mask <= [^;]+;\n','\n',s,flags=re.M)
        s=re.sub(r' got_mask\[[0-3]\] <= 1;', '',s)
        s=s.replace(" || (got_mask != 4'b1111)",'')
    p.write_text(s,encoding='utf-8')

if __name__=='__main__':
    import sys
    apply(sys.argv[1])
