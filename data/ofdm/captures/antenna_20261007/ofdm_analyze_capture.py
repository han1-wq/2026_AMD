import csv
import glob
import json
import math
from collections import Counter

def load(path):
    with open(path) as f:
        rows = list(csv.reader(f))
    names = [s.split('/')[-1] for s in rows[0]]
    radix = rows[1]
    return {name: [int(r[i], 16 if radix[i] == 'HEX' else 10) for r in rows[2:]] for i, name in enumerate(names)}

def signed(v, width):
    return v - (1 << width) if v >= (1 << (width-1)) else v

for path in sorted(glob.glob('/tmp/ofdm_capture_*.csv')):
    d = load(path)
    valid = d['w_rx_scaled_valid']
    ri = [signed(v,16)/16 for v in d['w_rx_scaled_i[15:0]']]
    rq = [signed(v,16)/16 for v in d['w_rx_scaled_q[15:0]']]
    tx = [i for i,v in enumerate(d['w_tx_sample_valid']) if v]
    rx = [i for i,v in enumerate(valid) if v]
    payload = bytes(b for b,v in zip(d['w_payload_byte[7:0]'],d['w_payload_valid']) if v)
    print(path, 'tx',len(tx), (tx[0],tx[-1]) if tx else None, 'rx cadence',Counter(b-a for a,b in zip(rx,rx[1:])))
    print('payload',len(payload),payload.hex(),'fcs',[(i,d['w_fcs_ok'][i]) for i,v in enumerate(d['w_fcs_strobe']) if v], 'lengths',Counter(d['w_rx_length[15:0]']))
    for a,b in [(0,64),(200,600),(600,1000),(1000,1400),(1400,1800),(2000,3000),(3000,4096)]:
        vals=[complex(ri[i],rq[i]) for i in rx if a<=i<b]
        print(a,b,'rms',round(math.sqrt(sum(abs(v)**2 for v in vals)/len(vals)),2),'peak',max(max(abs(v.real),abs(v.imag)) for v in vals),'mean',sum(vals)/len(vals))