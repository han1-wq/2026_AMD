"""Map/scan checks shared by the guard and isolated tests (Python 2/3)."""
from __future__ import division
import hashlib
import json
import math

import numpy as np


def map_identity(info, angle, data):
    metadata = {'frame': 'map', 'width': info.width, 'height': info.height,
                'resolution': info.resolution,
                'origin': [info.origin.position.x, info.origin.position.y, angle]}
    digest = hashlib.sha256(json.dumps(metadata, sort_keys=True, separators=(',', ':')).encode('ascii'))
    digest.update(np.asarray(data, dtype=np.int8).tostring())
    metadata['sha256'] = digest.hexdigest()
    return metadata


def ray_conflicts(grid, resolution, origin, endpoints, tolerance):
    """Fraction of returns whose free path crosses occupied map cells.

    Coordinates are already in grid metres. Unknown/out-of-map cells do not
    count as walls. Endpoint tolerance handles small pose/range errors; unlike
    dilated endpoint matching, an intervening wall cannot support a match.
    This does NOT establish uniqueness in a symmetric map.
    """
    delta = endpoints - np.asarray(origin).reshape(2, 1)
    lengths = np.sqrt((delta*delta).sum(axis=0))
    if not len(lengths) or not np.isfinite(lengths).all():
        raise ValueError('invalid ray endpoints')
    # Bound work and fail closed rather than silently undersampling long rays.
    count = int(math.ceil(float(lengths.max())/(resolution*.5)))
    if count > 4000:
        raise ValueError('scan ray exceeds checking budget')
    steps = np.arange(1, count+1)*resolution*.5
    active = (steps[:, None] < lengths[None, :]-tolerance) & (steps[:, None] > tolerance)
    points = (np.asarray(origin).reshape(2, 1, 1) + delta[:, None, :] *
              (steps[:, None]/np.maximum(lengths[None, :], 1e-9))[None, :, :])
    ix, iy = np.floor(points/resolution).astype(int)
    inside = active & (ix >= 0) & (iy >= 0) & (ix < grid.shape[1]) & (iy < grid.shape[0])
    blocked = np.zeros(inside.shape, dtype=bool)
    blocked[inside] = grid[iy[inside], ix[inside]] >= 65
    return float(blocked.any(axis=0).sum())/len(lengths)