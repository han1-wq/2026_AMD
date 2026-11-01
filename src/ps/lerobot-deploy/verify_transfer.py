"""Cross-architecture ACT weight transfer check, with synthetic data only."""
import argparse
import hashlib
import json
import platform
from pathlib import Path

import numpy as np
import torch

from lerobot.configs.types import FeatureType, PolicyFeature
from lerobot.configs.policies import PreTrainedConfig
from lerobot.policies.act.configuration_act import ACTConfig
from lerobot.policies.act.modeling_act import ACTPolicy


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('mode', choices=['export', 'verify'])
    parser.add_argument('directory', type=Path)
    args = parser.parse_args()
    root = args.directory
    torch.set_num_threads(2)
    torch.manual_seed(42)
    checkpoint = root / 'pretrained_model'
    if args.mode == 'export':
        root.mkdir(parents=True, exist_ok=False)
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
        policy = ACTPolicy(config).train()
        batch = {'observation.state': torch.rand(1, 6),
                 'observation.images.front': torch.rand(1, 3, 64, 64)}
        optimizer = torch.optim.AdamW(policy.parameters(), lr=1e-5)
        loss, _ = policy({**batch, 'action': torch.rand(1, 4, 6),
                          'action_is_pad': torch.zeros(1, 4, dtype=torch.bool)})
        assert torch.isfinite(loss)
        loss.backward()
        optimizer.step()
        policy.eval().save_pretrained(checkpoint)
        np.savez(root / 'inputs.npz', **{k: v.numpy() for k, v in batch.items()})
        with torch.inference_mode():
            np.save(root / 'expected.npy', policy.predict_action_chunk(batch).numpy())
        files = sorted(p for p in root.rglob('*') if p.is_file())
        (root / 'sha256.json').write_text(json.dumps({str(p.relative_to(root)):
            hashlib.sha256(p.read_bytes()).hexdigest() for p in files}, indent=2))
        print('EXPORT_PASS', float(loss.detach()))
    else:
        for name, digest in json.loads((root / 'sha256.json').read_text()).items():
            assert hashlib.sha256((root / name).read_bytes()).hexdigest() == digest, name
        config = PreTrainedConfig.from_pretrained(checkpoint)
        config.device = 'cpu'
        policy = ACTPolicy.from_pretrained(checkpoint, config=config, strict=True).eval()
        with np.load(root / 'inputs.npz') as data:
            batch = {k: torch.from_numpy(data[k]) for k in data.files}
        with torch.inference_mode():
            actual = policy.predict_action_chunk(batch)
        expected = torch.from_numpy(np.load(root / 'expected.npy'))
        torch.testing.assert_close(actual, expected, rtol=1e-4, atol=1e-5)
        report = {'passed': True, 'architecture': platform.machine(),
                  'max_absolute_error': (actual - expected).abs().max().item(),
                  'rtol': 1e-4, 'atol': 1e-5, 'shape': list(actual.shape),
                  'all_transferred_sha256_verified': True,
                  'note': 'One synthetic training update of reduced ACT; not a real task checkpoint.'}
        (root / 'transfer-result.json').write_text(json.dumps(report, indent=2) + '\n')
        print(json.dumps(report, indent=2))
        print('TRANSFER_PASS')


if __name__ == '__main__':
    main()