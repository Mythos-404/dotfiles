def _():
    from IPython.core.getipython import get_ipython

    ip = get_ipython()
    if ip is None:
        return
    if ip.alias_manager is None:
        return

    _ls = "eza --icons --color-scale --group-directories-first"
    _ll = f"{_ls} -lh"
    _l = f"{_ll} -a"
    ip.alias_manager.define_alias("ls", _ls)
    ip.alias_manager.define_alias("ll", _ll)
    ip.alias_manager.define_alias("l", _l)
_()
