"""Offline CPU environment checks. Never opens cameras or robot devices."""
import argparse
import importlib.metadata
import json
import platform
import resource
import tempfile
import time
from pathlib import Path

import av
import numpy as np
import torch
import torchvision

from lerobot.configs.types import FeatureType, PolicyFeature
from lerobot.datasets.video_utils import decode_video_frames, get_safe_default_codec
from lerobot.policies.act.configuration_act import ACTConfig
from lerobot.policies.act.modeling_act import ACTPolicy


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', required=True)
    parser.add_argument('--train', action='store_true')
    args = parser.parse_args()
    torch.set_num_threads(2)
    torch.manual_seed(42)
    assert torch.version.cuda is None, 'Expected a CPU-only torch build'
    boxes = torch.tensor([[0., 0., 10., 10.], [0., 0., 10., 10.]])
    assert torchvision.ops.nms(boxes, torch.tensor([.9, .8]), .5).tolist() == [0]
    config = ACTConfig(
        device='cpu', pretrained_backbone_weights=None,
        input_features={
            'observation.state': PolicyFeature(FeatureType.STATE, (6,)),
            'observation.images.front': PolicyFeature(FeatureType.VISUAL, (3, 64, 64)),
        },
        output_features={'action': PolicyFeature(FeatureType.ACTION, (6,))},
        chunk_size=4, n_action_steps=4, dim_model=64, n_heads=4,
        dim_feedforward=128, n_encoder_layers=1, n_decoder_layers=1,
        n_vae_encoder_layers=1,
    )
    policy = ACTPolicy(config).eval()
    batch = {'observation.state': torch.zeros(1, 6),
             'observation.images.front': torch.rand(1, 3, 64, 64)}
    times = []
    with torch.inference_mode():
        policy.predict_action_chunk(batch)
        for _ in range(3):
            start = time.perf_counter()
            result = policy.predict_action_chunk(batch)
            times.append(time.perf_counter() - start)
        assert result.shape == (1, 4, 6) and torch.isfinite(result).all()
    training_loss = None
    if args.train:
        policy.train()
        training = {**batch, 'action': torch.zeros(1, 4, 6),
                    'action_is_pad': torch.zeros(1, 4, dtype=torch.bool)}
        optimizer = torch.optim.AdamW(policy.parameters(), lr=1e-5)
        loss, _ = policy(training)
        assert torch.isfinite(loss)
        loss.backward()
        optimizer.step()
        training_loss = loss.item()
    policy.eval()
    with tempfile.TemporaryDirectory() as tmp:
        checkpoint = Path(tmp) / 'pretrained_model'
        policy.save_pretrained(checkpoint)
        restored = ACTPolicy.from_pretrained(checkpoint)
        with torch.inference_mode():
            torch.testing.assert_close(policy.predict_action_chunk(batch), restored.predict_action_chunk(batch))
        video = Path(tmp) / 'sample.mp4'
        with av.open(str(video), 'w') as container:
            stream = container.add_stream('libx264', rate=10)
            stream.width = stream.height = 64
            stream.pix_fmt = 'yuv420p'
            for i in range(5):
                frame = av.VideoFrame.from_ndarray(np.full((64, 64, 3), i * 40, dtype=np.uint8), format='rgb24')
                for packet in stream.encode(frame):
                    container.mux(packet)
            for packet in stream.encode():
                container.mux(packet)
        decoded = decode_video_frames(video, [0., .1, .2], .05)
        assert decoded.shape == (3, 3, 64, 64) and torch.isfinite(decoded).all()
    report = {
        'passed': True, 'architecture': platform.machine(), 'python': platform.python_version(),
        'versions': {name: importlib.metadata.version(name) for name in
                     ['lerobot', 'torch', 'torchvision', 'av', 'numpy', 'feetech-servo-sdk']},
        'video_backend': get_safe_default_codec(), 'torch_cuda': torch.version.cuda,
        'synthetic_reduced_act_chunk_seconds': times, 'training_loss': training_loss,
        'max_rss_kib': resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
        'note': 'Random reduced ACT, one 64x64 image. Not a trained model or real-robot performance guarantee.',
    }
    Path(args.output).write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))
    print('ENVIRONMENT_PASS')


if __name__ == '__main__':
    main()