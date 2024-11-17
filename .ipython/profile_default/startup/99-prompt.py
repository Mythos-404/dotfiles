def _():
    from pathlib import Path

    from IPython.core.getipython import get_ipython
    from IPython.terminal.prompts import Prompts
    from prompt_toolkit.enums import EditingMode
    from pygments.token import Token

    class MyPrompts(Prompts):
        def vi_mode(self) -> str:
            if (
                getattr(self.shell.pt_app, "editing_mode", None) == EditingMode.VI
                and self.shell.prompt_includes_vi_mode
            ):
                mode = str(self.shell.pt_app.app.vi_state.input_mode)
                if mode.startswith("InputMode."):
                    mode = mode[10:13].lower()
                elif mode.startswith("vi-"):
                    mode = mode[3:6]
                return mode
            return ""

        def in_prompt_tokens(self):
            vi_mode = self.vi_mode()
            if vi_mode == "ins":
                return [
                    (Token.Prompt, "[" + Path().absolute().stem + "]"),
                    (Token.Prompt, "|"),
                    (Token.PromptNum, str(self.shell.execution_count)),
                    (Token.Prompt, "> "),
                ]
            elif vi_mode == "rep":
                return [
                    (Token.Prompt, "[" + Path().absolute().stem + "]"),
                    (Token.Prompt, "|"),
                    (Token.PromptNum, str(self.shell.execution_count)),
                    (Token.OutPrompt, "| "),
                ]
            else:
                return [
                    (Token.Prompt, "[" + Path().absolute().stem + "]"),
                    (Token.Prompt, "|"),
                    (Token.PromptNum, str(self.shell.execution_count)),
                    (Token.Prompt, "| "),
                ]

        def out_prompt_tokens(self):
            return [
                (Token.Prompt, " " * len(Path().absolute().stem)),
                (Token.OutPrompt, "  <"),
                (Token.OutPromptNum, str(self.shell.execution_count)),
                (Token.OutPrompt, "> "),
            ]

        def continuation_prompt_tokens(self, width=None, *, lineno=None):
            if width is None:
                width = self._width()
            prefix = " " * (len(self.vi_mode()) + len(Path().absolute().stem) + len(str(self.shell.execution_count)))
            return [
                (
                    Token.Prompt,
                    prefix + (" " * (width - len(prefix) - 5)) + "  |",
                ),
            ]

    ip = get_ipython()
    if ip is None:
        return
    ip.prompts = MyPrompts(ip)  # pyright:ignore [reportAttributeAccessIssue]
_()
