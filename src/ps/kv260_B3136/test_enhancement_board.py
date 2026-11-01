"""Independent constant/ramp pixel checks on the deployed HLS preview/tensor."""
import json
import numpy as np
from runtime.controls import Controls


def run_checks(hw):
    slot = hw.slots[0]
    slot.frame = np.empty((480, 640, 3), np.uint8)
    slot.frame[:] = (20, 100, 220)
    checks = []
    def apply(settings):
        slot.sequence += 1
        hw.preprocess(slot, settings)
        return slot.enhanced
    def quant(values):
        return np.clip(np.rint(np.asarray(values)*2.**(hw.fix-8)), -128, 127).astype(np.int8)
    # Preview enhancements must not alter the original inference branch.
    baseline = apply(Controls())
    np.testing.assert_array_equal(baseline, slot.frame)
    original_tensor = slot.tensor.copy()
    adjusted = apply(Controls(contrast=1.5, brightness=25))
    expected = np.clip(np.rint(1.5*(np.array([20,100,220])-128)+128+25), 0, 255).astype(np.uint8)
    np.testing.assert_array_equal(adjusted, np.broadcast_to(expected, adjusted.shape))
    np.testing.assert_array_equal(slot.tensor, original_tensor)
    checks.append('brightness_contrast_preview_original_tensor')
    apply(Controls(contrast=1.5, brightness=25, enhance_tensor=True))
    np.testing.assert_array_equal(slot.tensor[0,52:364], np.broadcast_to(quant(expected[::-1]), (312,416,3)))
    checks.append('enhanced_tensor_branch')
    gray = apply(Controls(saturation=0))
    luminance = (29*20+150*100+77*220+128)>>8
    np.testing.assert_array_equal(gray, np.full(gray.shape, luminance, np.uint8))
    checks.append('saturation_zero_luma')
    saturated = apply(Controls(saturation=2))
    expected = np.clip(luminance+2*(np.array([20,100,220])-luminance),0,255).astype(np.uint8)
    np.testing.assert_array_equal(saturated, np.broadcast_to(expected, saturated.shape))
    checks.append('saturation_two_clipping')
    # A grayscale half-frame distribution makes the CDF result unambiguous.
    slot.frame[:, :320] = 50
    slot.frame[:, 320:] = 150
    expected = np.empty_like(slot.frame)
    expected[:, :320] = 0
    expected[:, 320:] = 255
    np.testing.assert_array_equal(apply(Controls(eq_mode=1)), expected)
    checks.append('current_frame_histogram')
    np.testing.assert_array_equal(apply(Controls(eq_mode=2)), slot.frame)
    np.testing.assert_array_equal(apply(Controls(eq_mode=2)), expected)
    checks.append('previous_frame_startup_and_history')
    changed = apply(Controls(eq_mode=2, brightness=10))
    np.testing.assert_array_equal(changed, slot.frame+10)
    checks.append('configuration_change_resets_history')
    print('ENHANCEMENT_TEST_OK '+json.dumps(dict(checks=checks, config_id=hw.config_id)), flush=True)