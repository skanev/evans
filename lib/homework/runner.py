import imp
import io
import json
import os
import sys
import unittest


class StdBuffer:
    def __init__(self, buffer):
        self.buffer = buffer

    def __enter__(self):
        self.stds = sys.stdin, sys.stderr, sys.stdout
        sys.stdin = self.buffer
        sys.stderr = self.buffer
        sys.stdout = self.buffer

    def __exit__(self, *args, **kwargs):
        sys.stdin, sys.stderr, sys.stdout = self.stds


class EmptyTestResult:
    failures = []
    errors = []
    testsRun = 0
    log = ''


def main(test_module):
    buffer = io.StringIO()
    sys.path = [os.path.dirname(test_module)] + sys.path

    with StdBuffer(buffer):
        try:
            test = imp.load_source('test', test_module)
            result = unittest.main(module=test, buffer=buffer, exit=False).result
        except Exception as e:
            result = EmptyTestResult()
            result.log = e

    output = {
        'failed': len(result.failures) + len(result.errors),
        'log': buffer.getvalue(),
    }
    output['passed'] = result.testsRun - output['failed']

    print(json.dumps(output))


if __name__ == '__main__':
    main(sys.argv.pop())
