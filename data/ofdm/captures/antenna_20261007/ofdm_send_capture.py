import json
import sys
import serial
import random
sys.path.insert(0, '/home/amd/ofdm/eeSDR_ofdm_loopback/host')
import serial_packet as sp
seq = int(sys.argv[1])
payload = bytes(random.Random(seq).sample(range(256), 64)) if seq >= 120 else bytes(range(64))
with serial.Serial(sp.DEFAULT_PORT, 115200, timeout=.1, write_timeout=1, exclusive=True) as port:
    port.reset_input_buffer()
    port.write(sp.frame(payload, seq))
    status, flags, length, rx = sp.receive(port, seq)
result = dict(seq=seq, status=status, flags=flags, length=length, tx=payload.hex(), rx=rx.hex())
with open('/tmp/ofdm_capture_%d.json' % seq, 'w') as out:
    json.dump(result, out, indent=2)
print(json.dumps(result))