def _():
    from IPython.core.getipython import get_ipython

    if (ip := get_ipython()) is None:
        return

    macro_pairs = [
        ("..", "os.chdir('..')"),
        ("...", "os.chdir('../..')"),
        ("....", "os.chdir('../../..')"),
        (".....", "os.chdir('../../../..')"),
        ("......", "os.chdir('../../../../..')"),
        ("q", "exit()"),
    ]

    for alias, command in macro_pairs:
        ip.define_macro(alias, command)
_()
