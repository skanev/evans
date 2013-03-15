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
    all_tests = []
    failures = []
    errors = []
    log = ''


class DiligentTextTestRunner(unittest.TextTestRunner):
    all_tests = []

    def run(self, test):
        result = super().run(test)
        for test_suite in test._tests:
            for test in test_suite._tests:
                self.all_tests.append(test.__str__())
        result.all_tests = self.all_tests
        return result


def main(test_module):
    buffer = io.StringIO()
    sys.path = [os.path.dirname(test_module)] + sys.path

    with StdBuffer(buffer):
        try:
            test = imp.load_source('test', test_module)
            result = unittest.main(
                module=test,
                buffer=buffer,
                exit=False,
                testRunner=DiligentTextTestRunner
            ).result
        except Exception as e:
            result = EmptyTestResult()
            result.log = e

    failed = [test[0].__str__() for test in result.failures + result.errors]
    passed = [test for test in result.all_tests if test not in failed]

    return {
        'passed': passed,
        'failed': failed,
        'log': buffer.getvalue(),
    }


if __name__ == '__main__':
    print(json.dumps(main(sys.argv.pop())))
