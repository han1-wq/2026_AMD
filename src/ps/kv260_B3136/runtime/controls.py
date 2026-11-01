"""Validated, atomic desktop controls; no hardware imports."""
from dataclasses import asdict, dataclass
import json
import math
from pathlib import Path


@dataclass(frozen=True)
class Controls:
    contrast: float = 1.0
    brightness: int = 0
    saturation: float = 1.0
    eq_mode: int = 0
    enhance_tensor: bool = False
    display_mode: str = 'enhanced'

    @classmethod
    def parse(cls, values):
        if not isinstance(values, dict) or set(values) - set(cls.__dataclass_fields__):
            raise ValueError('Unknown visual control')
        result = cls(**values)
        for name, high in (('contrast', 4), ('saturation', 2)):
            value = getattr(result, name)
            if isinstance(value, bool) or not isinstance(value, (float, int)) or not math.isfinite(value) or not 0 <= value <= high:
                raise ValueError(name + ' outside hardware range')
        if type(result.brightness) is not int or not -255 <= result.brightness <= 255:
            raise ValueError('brightness outside [-255,255]')
        if type(result.eq_mode) is not int or result.eq_mode not in (0, 1, 2):
            raise ValueError('Invalid histogram mode')
        if type(result.enhance_tensor) is not bool or result.display_mode not in ('original', 'enhanced'):
            raise ValueError('Invalid inference/display selection')
        return result

    def hardware_key(self):
        return (self.contrast, self.brightness, self.saturation, self.eq_mode, self.enhance_tensor)


def atomic_write(path, data):
    path = Path(path)
    temporary = path.with_name(path.name + '.tmp')
    temporary.write_bytes(data)
    temporary.replace(path)


def write_json(path, values):
    atomic_write(path, (json.dumps(values, ensure_ascii=False, allow_nan=False) + '\n').encode())


class ControlReader:
    def __init__(self, directory):
        self.directory = Path(directory) if directory else None
        self.current = Controls()
        self.version = None

    def read(self):
        if self.directory:
            path = self.directory / 'controls.json'
            try:
                stat = path.stat()
                version = (stat.st_mtime_ns, stat.st_ino, stat.st_size)
                if version != self.version:
                    self.version = version
                    self.current = Controls.parse(json.loads(path.read_text()))
            except FileNotFoundError:
                pass
            except (OSError, ValueError, TypeError) as exc:
                print('CONTROL_REJECTED ' + str(exc), flush=True)
        return self.current

    def status(self, **values):
        if self.directory:
            write_json(self.directory / 'status.json', values)

    def stop_requested(self):
        return self.directory and (self.directory / 'stop').exists()