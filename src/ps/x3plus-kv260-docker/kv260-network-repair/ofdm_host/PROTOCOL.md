# Single-board SG-DMA loopback

The current DMA build uses **one board**: host -> UART or TCP -> DMA -> OFDM
TX -> transmit antenna -> receive antenna -> OFDM RX -> DMA -> the same board's
UART or TCP -> host. No second board or application-level radio echo is needed.
The returned business data comes from RX, not a PS software copy of TX.

Load `/home/amd/ofdm/eeSDR_ofdm_loopback/release_dma/TOP.bit` and
`/home/amd/ofdm/eeSDR_ofdm_loopback/release_dma/ofdm_dma_board10.elf`, after PS/DDR
initialization. Wait for the `DMA ready` boot line. UART is 115200 8N1.
Use these DMA clients (the historical GUI/protocol below is incompatible):

```sh
python3 /home/amd/ofdm/eeSDR_ofdm_loopback/host/dma_uart.py auto --hex 00112233445566778899aabbccddeeff
python3 /home/amd/ofdm/eeSDR_ofdm_loopback/host/dma_image.py loopback 192.168.1.10 /absolute/path/original.png --output /absolute/path/returned.png
sha256sum /absolute/path/original.png /absolute/path/returned.png
```

The UART tool needs the existing `pyserial` dependency and uses the same FT2232
interface discovery as the old tools. An explicit serial device path can replace
`auto`. Payloads are 1..1000 bytes; without `--hex` a random 64-byte payload is
used. Only one UART request should be outstanding. Close other serial tools.
The tool requires local enqueue acceptance **and matching RX data**, compares
every payload byte, and reports `UART LOOPBACK PASS` only after both arrive.

DMA UART request: `A5 5A | packet length (2 LE) | OF packet`.
Response: `5A A5 | record length (2 LE) | record`. A one-byte record is local
enqueue status (0 accepted, 1 busy, 2 invalid); a longer record is an RX packet.
An `OF` packet has the 24-byte header defined by `HEADER` in `dma_image.py`:
magic `OF`, version 1, type, flags 0, channel, session (4), message (4), fragment
index (2), fragment count (2), payload length (2), total length (4); multi-byte
fields are little-endian. UART type is 1, index 0, count 1, and total length
equals payload length. Each invocation uses fresh session/message IDs.

Images use Ethernet TCP port 5001, with a host address distinct from 192.168.1.10
on the 192.168.1.0/24 subnet. The board accepts only one TCP client. `loopback`
concurrently uploads and drains RX records on **one connection**, reconstructs
the returned file, verifies CRC32 and exact byte equality, and waits for the
board's CRC result and ACK-window completion. Only then is the destination
replaced and `LOOPBACK PASS` printed, with SHA256. Source and destination must
differ. Supported file sizes are 1 byte..16 MiB; `--timeout` is a socket operation
timeout (default 120 seconds). `send`/`receive` are retained for two-endpoint
transport; running both against this one board is not the loopback procedure.

Tests exercise the real firmware service/link state machines with simulated
radio returns and the host clients with simulated UART/TCP streams. They are
not physical-board RF validation.

# Historical mailbox UART packet loopback

The remainder describes the pre-DMA firmware and its existing GUI/CLI only.

UART1 is configured for 115200 8N1 on PS MIO12/MIO13. Confirm the physical
connector wiring and common ground before connecting a 3.3 V UART adapter.
The firmware prints its AD9361 initialization log on this UART; wait until
initialization finishes before sending binary frames. No text is printed after
the packet loop begins. Only one request may be outstanding.

Request: `A5 5A | seq (1) | payload (64) | CRC16 (2)` (69 bytes).
Response: `5A A5 | seq (1) | result (1) | flags (1) | length (2) |
payload (64) | CRC16 (2)` (73 bytes). All multi-byte fields are little-endian.
CRC16-CCITT-FALSE covers every byte before the CRC, init `0xffff`, polynomial
`0x1021`, no reflection, no xor-out. A request with bad CRC receives result 2.
Result: 0 verified pass, 1 PL failure, 2 UART CRC error, 3 mailbox busy,
4 PS wait timeout. Flags bit 0 = verified pass, bit 1 = FCS OK, bit 2 =
length/data mismatch, bit 3 = TX error, bit 4 = PL timeout. The returned
64 bytes are zero-padded after the received bytes. RX length reports the
decoder's packet length; overflow of the 64-byte buffer is a mismatch.

The AXI-Lite mailbox base is `0x43C10000` (separate from the legacy
`0x43C00000` TR_mode register). Offset `0x00` write bit 0 starts a request;
`0x04` read has busy bit 0, done bit 1, and flags in bits 6:2;
`0x08` gives 16-bit RX length. TX words are at `0x40..0x7c`, RX words at
`0x80..0xbc`; each word stores four sequential bytes little-endian. Writes
while busy return AXI SLVERR. RX reads before done return zero. The next
start clears done and preserves the previous snapshot until new completion.

Run `python3 host/serial_packet.py` after programming matching PL and PS images.
The default port is `auto`: enumerate USB VID/PID `0403:6010` and select only
FT2232 interface **1** (zero-based, channel B). The Linux USB descriptor
`bInterfaceNumber` is used, with pyserial's numeric USB location as fallback.
Product descriptions, hard-coded serial numbers and tty numbering are not used
to determine the interface. Unknown interface numbers are never guessed.
Pass an explicit port as an argument for other adapters.
Do not assume `/dev/ttyUSB0`: it may be used by the JTAG interface or disappear
while the board is in use. The tool requires `pyserial` and exits nonzero on a failed
loopback or corrupted response. For a chosen payload, supply `--hex` followed
by exactly 128 hexadecimal digits.

Desktop console: run `python3 host/serial_gui.py`. Leave the selection at `auto`
and click Connect. The console waits if no target is present, and checks every
second for removal/re-enumeration. On reconnect it resolves the current device
path again. Disconnect / Stop cancels this behavior. The display settles for one
second after opening before enabling Send; firmware readiness is not implied.
Wait for firmware initialization to finish, then send a random or hexadecimal
64-byte payload. Multiple matching devices are reported as ambiguous; choose a
specific FT2232 entry from the list after stopping and refreshing. Specific
entries are tracked by serial number (USB location also used for missing or
duplicate serial numbers). Explicitly entered device paths are manual overrides
and do not provide automatic hardware identity tracking.
The console uses the same framing and CRC implementation as the command-line
tool. Both tools enforce a two-second response deadline. Do not open the same
port in another terminal while using the console. On Linux the current user
needs permission to access the serial device, typically via the `dialout` group.
Use `id` to check membership in the current session and `id "$USER"` to check
the persistent membership. If the latter includes `dialout` but the former does
not, log out of the desktop session and back in, then restart VS Code and the
console. A temporary `chmod` on `/dev/ttyUSB*` is lost on USB reconnect.

The default `auto` selection also accepts a replacement device with a new serial
number/product string when exactly one matching interface is present. If a
selected device's serial changes, switch back to `auto` or select the new entry.
Changes to VID/PID, interface layout, UART settings or wire protocol require
configuration/code changes; USB descriptors cannot prove the attached firmware
implements this protocol. Only a successful response verifies communication.

CLI options (usable over SSH, without a desktop):

```bash
python3 /home/ubuntu/ofdm-host/serial_packet.py --list
python3 /home/ubuntu/ofdm-host/serial_packet.py --detect
python3 /home/ubuntu/ofdm-host/serial_packet.py --wait 30 --settle 3
python3 /home/ubuntu/ofdm-host/serial_packet.py --serial-number 0ABC01
```

`--list` and `--detect` do not open or transmit to any port. `--wait` retries
discovery/opening only, never a transmitted packet. `--location` selects the USB
location printed by `--list`; `--timeout` configures the response deadline (CLI).
Failures return code 1 for a negative loopback result, 2 for connection/protocol
errors and 130 for interruption. Input is validated and failures are printed
without a Python traceback. An absent device fails immediately unless `--wait`
is supplied. Ambiguity always fails immediately in the CLI.

Both tools use the same transport configuration and request exclusive access
on Linux (cooperating applications only). DTR/RTS are deasserted before opening;
some drivers/hardware may still glitch these lines during open. The receiver
resynchronizes past corrupt frames and stale sequence numbers within the original
deadline. Transactions are never automatically replayed after a failure. The GUI
retains at most roughly 10,000 log lines / 1,000,000 characters.

KV260 deployment: copy this directory's `.py` files and documentation to
`/home/ubuntu/ofdm-host`. Requires Python 3.8+, `pyserial` (tested with 3.5) and
Tkinter for the GUI. Ubuntu packages are `python3-serial` and `python3-tk`.
Run `python3 /home/ubuntu/ofdm-host/serial_gui.py` from the KV260 desktop terminal;
ordinary SSH has no graphical display, so use the CLI there (or configured X11
forwarding). No root privileges, new udev rules, or background service are needed
when the account already belongs to `dialout`.

Tests, including USB identity/reconnect cases and an OS pseudo-terminal exchange:
`python3 -B -m unittest discover -s /home/ubuntu/ofdm-host -p 'test_*.py' -v`.
On the development PC replace that directory with the local `host` directory.
