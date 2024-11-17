def _():
    import os

    from IPython.core.getipython import get_ipython
    from IPython.core.magic import (
        register_cell_magic,
        register_line_magic,
        register_line_cell_magic,
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
    def cpp(_, cell):
        """
        Compile, execute C++ code, and return the
        standard output.
        """
        # We first retrieve the current IPython interpreter
        # instance.
        if (ip := get_ipython()) is None:
            return

        # We define the source and executable filenames.
        source_filename = "_temp.cpp"
        program_filename = "_temp"

        # We write the code to the C++ file.
        with open(source_filename, "w") as f:
            f.write(cell)

        # We compile the C++ code into an executable.
        _ = ip.getoutput(f"g++ {source_filename} -o {program_filename} -std=c++2b")

        # We execute the executable and return the output.
        output = ip.getoutput(f"./{program_filename}")

        # Remove compile files
        os.remove(source_filename)
        os.remove(program_filename)

        print("n".join(output))
_()
