#!/usr/bin/env python3

importok = True
try:
    import causal_conv1d
except ImportError as e:
    importok = False
    print(e)
try:
    import mamba_ssm
except ImportError as e:
    importok = False
    print(e)
import torch

if importok:
    print("done")
