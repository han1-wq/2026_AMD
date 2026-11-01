import csv, cmath, math, sys
from pathlib import Path

def load(path):
    with open(path) as f: rows = list(csv.reader(f))
    names = [x.split('/')[-1] for x in rows[0]]
    return {n: [int(r[i], 16 if rows[1][i] == 'HEX' else 10) for r in rows[2:]] for i,n in enumerate(names)}

def samples(d, prefix, width, scale=1):
    def signed(x): return x - 2**width if x >= 2**(width-1) else x
    return [complex(signed(i),signed(q))/scale for i,q,v in zip(
        d[f'{prefix}_i[{width-1}:0]'], d[f'{prefix}_q[{width-1}:0]'], d[prefix+'_valid']) if v]

def dft(x):
    return [sum(v*cmath.exp(-2j*math.pi*k*n/64) for n,v in enumerate(x)) for k in range(64)]

def rms(x): return math.sqrt(sum(abs(v)**2 for v in x)/len(x))

if __name__ == '__main__':
    path=sys.argv[1]; d=load(path)
    tx=samples(d,'w_tx_scaled',12)[:640]; rx=samples(d,'w_rx_scaled',16,16)
    with open(path+'.txt','w') as f:
        for i,q,v in zip(d['w_rx_scaled_i[15:0]'], d['w_rx_scaled_q[15:0]'], d['w_rx_scaled_valid']):
            f.write(f'{v} {i} {q}\n')
    # Locate the first useful LTS (TX offset 192) by normalized correlation.
    ref=tx[192:256]
    correlations=[]
    for start in range(0,400):
        y=rx[start+192:start+256]
        h=sum(a.conjugate()*b for a,b in zip(ref,y))/sum(abs(a)**2 for a in ref)
        correlations.append((rms([b-h*a for a,b in zip(ref,y)])/rms(y),start,h))
    err,start,h=min(correlations)
    print('RX_START',start,'single tap residual',err,'h',h)
    phase=cmath.phase(sum(a.conjugate()*b for a,b in zip(rx[start+192:start+256],rx[start+256:start+320])))
    omega=phase/64
    print('LTS_CFO_HZ',omega*40e6/(2*math.pi))
    rx=[v*cmath.exp(-1j*omega*(n-start)) for n,v in enumerate(rx)]
    bins=list(range(1,27))+list(range(38,64)); pilots=[7,21,43,57]
    tlt=dft(tx[192:256]); rlt1=dft(rx[start+192:start+256]);rlt2=dft(rx[start+256:start+320])
    channel={k:(rlt1[k]+rlt2[k])/2/tlt[k] for k in bins}
    print('LTS_REPEAT_EVM',rms([rlt1[k]-rlt2[k] for k in bins])/rms([(rlt1[k]+rlt2[k])/2 for k in bins]))
    print('CHANNEL_MAG',[(k,round(abs(channel[k]),3)) for k in bins])
    for sym in range(4):
        off=336+80*sym
        t=dft(tx[off:off+64]); r=dft(rx[start+off:start+off+64])
        eq={k:r[k]/channel[k] for k in bins}
        cpe=cmath.phase(sum(eq[k]*t[k].conjugate() for k in pilots))
        errs=[eq[k]*cmath.exp(-1j*cpe)-t[k] for k in bins]
        print('SYMBOL',sym,'pilot CPE deg',cpe*180/math.pi,'EVM',rms(errs)/rms([t[k] for k in bins]),'pilot phase',[(k,round(cmath.phase(eq[k]/t[k])*180/math.pi,1)) for k in pilots])
        print('BIN_ERROR',[(k,round(abs(eq[k]*cmath.exp(-1j*cpe)-t[k])/rms([t[j] for j in bins]),3)) for k in bins])