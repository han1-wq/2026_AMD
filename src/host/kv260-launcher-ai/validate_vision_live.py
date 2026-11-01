"""Board GUI integration test: real Tk controls, HLS acknowledgement and stop."""
import json
from pathlib import Path
import sys
import time
import tkinter as tk
from launcher_vision_ui import VisionWindow, DIRECTORY

EVIDENCE = Path('/home/ubuntu/kv260_B3136/logs')
root = tk.Tk()
app = VisionWindow(root)
started = time.monotonic()
phase = 0
deadline = started + 45
evidence = []
failed = False
config_ids = []
cases = [
    dict(brightness=30, contrast=1.4, saturation=1.2, eq_mode=0, enhance_tensor=False, display_mode='enhanced'),
    dict(brightness=0, contrast=1., saturation=0., eq_mode=0, enhance_tensor=False, display_mode='enhanced'),
    dict(brightness=0, contrast=1., saturation=1., eq_mode=1, enhance_tensor=False, display_mode='enhanced'),
    dict(brightness=0, contrast=1., saturation=1., eq_mode=2, enhance_tensor=True, display_mode='enhanced'),
    dict(brightness=0, contrast=1., saturation=1., eq_mode=0, enhance_tensor=False, display_mode='original'),
    dict(brightness=0, contrast=1., saturation=1., eq_mode=0, enhance_tensor=False, display_mode='enhanced'),
]
current = None
applied = 0


def configure(values):
    for key in ('brightness', 'contrast', 'saturation'):
        app.values[key].set(values[key])
    app.eq.current(values['eq_mode'])
    app.enhance.set(values['enhance_tensor'])
    app.display.set(values['display_mode'])
    app.apply()


def poll():
    global phase, deadline, current, applied, failed
    try:
        now = time.monotonic()
        data = json.loads((DIRECTORY/'status.json').read_text())
        if now > deadline:
            raise RuntimeError('Live phase timeout: '+str(phase))
        if phase == 0 and data['state'] == 'running' and data['processed'] >= 10:
            assert data['depth_pairs'] > 0 and app.photo is not None
            phase = 1
            current = cases.pop(0)
            configure(current)
            applied = now
            deadline = now+15
        elif phase == 1 and data['state'] == 'running':
            settings = data['message']['preprocessing']
            acknowledged = all(settings.get(key) == value for key, value in current.items() if key != 'display_mode')
            if acknowledged and data['display_mode'] == current['display_mode'] and now-applied > 4:
                assert app.photo is not None and app.photo.width() == 640 and app.photo.height() == 480
                evidence.append(data)
                config_ids.append(settings['config_id'])
                print('GUI_CONTROL_ACK '+json.dumps(data), flush=True)
                if cases:
                    current = cases.pop(0)
                    configure(current)
                    applied = now
                    deadline = now+15
                else:
                    try:
                        from capture_desktop import capture
                        capture(EVIDENCE/'vision-live-desktop.png')
                    except Exception as exc:
                        print('SCREENSHOT_UNAVAILABLE '+str(exc), flush=True)
                    app.submit('stop-vision')
                    phase = 2
                    deadline = now+40
        elif phase == 2 and data['state'] == 'stopped' and data.get('cleanup_ok'):
            assert len(evidence) == 6
            assert config_ids == sorted(config_ids) and len(set(config_ids)) >= 5
            (EVIDENCE/'vision-live-validation.json').write_text(json.dumps(dict(success=True, cases=evidence, stop=data), indent=2))
            print('GUI_LIVE_TEST_OK', flush=True)
            app.close()
            return
    except FileNotFoundError:
        if time.monotonic() > deadline:
            failed = True
            print('GUI_LIVE_TEST_FAILED missing state', flush=True)
            app.close()
            return
    except Exception as exc:
        failed = True
        print('GUI_LIVE_TEST_FAILED '+repr(exc), flush=True)
        app.submit('stop-vision')
        app.close()
        return
    root.after(150, poll)


app.submit('vision')
root.after(300, poll)
root.mainloop()
raise SystemExit(1 if failed else 0)