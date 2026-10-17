from pypdf import PdfReader
r=PdfReader('C:/Anlogic/TD_6.2.1_SP1_6.2.178.840/doc/SWUG/SWUG106_HDL_Coding_Synthesis_User_Guide.pdf')
for i,p in enumerate(r.pages):
    t=p.extract_text() or ''
    if 'fsm_encoding' in t.lower() or 'syn_encoding' in t.lower() or ('safe' in t.lower() and 'fsm' in t.lower()):
        print('PAGE',i+1)
        print(t[:5500])
