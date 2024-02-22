import atexit
import collections
import datetime
import functools
import itertools
import math
import os
import random
import sys
import time

import orjson as json
from rich import inspect, print

# -------------- Useful Macros -----------------------------------------
ip = get_ipython()  # noqa: F821


def is_module_available(module_name):
    if sys.version_info < (3, 0):
        # python 2
        import imp

        try:
            imp.find_module(module_name)
        except ImportError:
            return False
        return True
    elif sys.version_info <= (3, 3):
        # python 3.0 to 3.3
        import pkgutil

        torch_loader = pkgutil.find_loader(module_name)
    elif sys.version_info >= (3, 4):
        # python 3.4 and above
        import importlib

        torch_loader = importlib.util.find_spec(module_name)

    return torch_loader is not None


macro_pairs = [
    ("ipy", "ipy=get_ipython()"),
    ("pd", "import pandas as pd"),
    ("np", "import numpy as np"),
    ("tf", "import tensorflow as tf"),
    ("t", "import torch as t"),
    ("..", "os.chdir('..')"),
    ("...", "os.chdir('../..')"),
    ("....", "os.chdir('../../..')"),
    (".....", "os.chdir('../../../..')"),
    ("......", "os.chdir('../../../../..')"),
    ("q", "exit()"),
]
if is_module_available("ipdb"):
    macro_pairs.append(("pm", "import ipdb; ipdb.pm()"))
else:
    macro_pairs.append(("pm", "import pdb; pdb.pm()"))

for alias, command in macro_pairs:
    ip.define_macro(alias, command)

del is_module_available, macro_pairs, alias, command

# --------------- Define My Own Magics ---------------------------------
from IPython.core.magic import (  # noqa: E402,I001
    register_cell_magic,
    register_line_cell_magic,
    register_line_magic,
)


@register_line_magic
def touch(line):
    for f in line.split():
        if not os.path.exists(f):
            with open(f, "a"):
                pass


@register_line_magic
def bak(line):
    for f in line.split():
        os.rename(f, f + ".bak")


@register_cell_magic
def cpp(line, cell):
    """Compile, execute C++ code, and return the
    standard output."""
    # We first retrieve the current IPython interpreter
    # instance.
    ip = get_ipython()  # noqa: F821

    # We define the source and executable filenames.
    source_filename = "_temp.cpp"
    program_filename = "_temp"

    # We write the code to the C++ file.
    with open(source_filename, "w") as f:
        f.write(cell)

    # We compile the C++ code into an executable.
    compile = ip.getoutput(  # noqa: F841
        f"g++ {source_filename} -o {program_filename} -std=c++2b"
    )

    # We execute the executable and return the output.
    output = ip.getoutput(f"./{program_filename}")

    # Remove compile files
    os.remove(source_filename)
    os.remove(program_filename)

    print("n".join(output))


del bak, touch, cpp

# --------------- Define aliases ---------------------------------------

_ls = "eza --icons --color-scale --group-directories-first"
_ll = f"{_ls} -lh"
_l = f"{_ll} -a"
ip.alias_manager.define_alias("ls", _ls)
ip.alias_manager.define_alias("ll", _ll)
ip.alias_manager.define_alias("l", _l)

del _ls, _ll, _l

del ip
