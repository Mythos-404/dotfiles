# pyright: standard, reportWildcardImportFromLibrary=false, reportUnusedImport=false
import collections
import datetime
import importlib.util
import math
import operator
import os
import random
import re
import sys
import time
from functools import *
from itertools import *

def _():
    modules = {
        "tq": ["tqdm"],
        "fn": ["funcy"],
        "mi": ["more_itertools"],
        "rtq": ["tqdm.rich"],
        "json": ["orjson"],
    }

    for alias, module in modules.items():
        if importlib.util.find_spec(module[0]) is not None:
            if len(module) == 1:
                globals().update({alias: importlib.import_module(module[0])})
            else:
                globals().update({alias: getattr(importlib.import_module(module[0]), module[1])})
_()
