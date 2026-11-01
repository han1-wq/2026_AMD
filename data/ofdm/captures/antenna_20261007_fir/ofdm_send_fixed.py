import json
import sys
import serial

sys.path.insert(0, '/home/amd/ofdm/eeSDR_ofdm_loopback/host')
import serial_packet as sp

seq = int(sys.argv[1])
payload = bytes.fromhex(sys.argv[2]) if len(sys.argv) > 2 else bytes(range(64))
with serial.Serial('/dev/ttyUSB1', 115200, timeout=0.1, write_timeout=1, exclusive=True) as port:
    port.reset_input_buffer()
    port.write(sp.frame(payload, seq))
    status, flags, length, received = sp.receive(port, seq)
result = dict(seq=seq, status=status, flags=flags, length=length,
              tx=payload.hex(), rx=received.hex())
with open('/tmp/ofdm_new_capture_%d.json' % seq, 'w') as out:
    json.dump(result, out, indent=2)
print(json.dumps(result))