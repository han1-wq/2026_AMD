#!/usr/bin/env python3
import argparse
from pathlib import Path
import webbrowser

parser = argparse.ArgumentParser()
parser.add_argument('--board', action='store_true')
args = parser.parse_args()
root = Path(__file__).resolve().parent
token = (root / ('board-ui.token' if args.board else 'ui.token')).read_text().strip()
address = '192.168.43.182:8089' if args.board else '127.0.0.1:8088'
webbrowser.open('http://' + address + '/#token=' + token)