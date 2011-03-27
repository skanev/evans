import sys
import imp
import io
import unittest

from contextlib import contextmanager

@contextmanager
def silence():
    stds = [sys.stdin, sys.stdout]
    sys.stdin = SilentFile()
    sys.stdout = SilentFile()
    try:
        yield
    finally:
        sys.stdin, sys.stdout = stds

class SilentFile:
    def write(*args, **kwargs): pass
    def read(*args, **kwargs): return ''
    def readline(*args, **kwargs): return "\n"

class Test(unittest.TestCase):
    @classmethod
    def main(rude, module = None): # Can't write "class", so "kind" would've been better. But I'm not kind, I'm rude
        with silence():
            rude.solution = module or imp.load_source('solution', sys.argv[1])

        buffer = io.StringIO()
        suite = unittest.TestSuite(map(rude, [_ for _ in dir(rude) if _.startswith('test_')]))

        with silence():
            result = unittest.TextTestRunner(buffer).run(suite)

        failures, errors = len(result.failures), len(result.errors)
        passed = result.testsRun - failures - errors

        print("%d %d" % (passed, failures + errors))
        print(buffer.getvalue())

