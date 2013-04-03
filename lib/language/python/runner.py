import imp
import io
import json
import os
import sys
import threading
import unittest
import traceback


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
        for suite_index, test_suite in enumerate(test._tests):
            for method_index, test_method in enumerate(test_suite._tests):
                self.all_tests.append(str(test_method))
                # We have to find a way to decorate each test
                # This line below does not work, because
                # "'TestSuite' object does not support indexing"
                # I'm thinking about creating my own TestSuite...
                test._tests[suite_index][method_index] = self.timeout(test_method)
        result = super().run(test)
        result.all_tests = self.all_tests
        return result

    @staticmethod
    def timeout(func, args=(), kwargs={}, timeout_duration=0.5):
        """This function will spawn a thread and run the given function
        using the args, kwargs and return the given default value if the
        timeout_duration is exceeded.
        """
        class InterruptableThread(threading.Thread):
            def __init__(self):
                super().__init__()
                self.result = None

            def run(self):
                self.result = func(*args, **kwargs)

        it = InterruptableThread()
        it.start()
        it.join(timeout_duration)
        if it.is_alive():
            it._stop()
            raise Exception('Timed out.')
        else:
            return it.result


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
            traceback.print_tb(e.__traceback__)

    failed = [str(test[0]) for test in result.failures + result.errors]
    passed = [test for test in result.all_tests if test not in failed]

    return {
        'passed': passed,
        'failed': failed,
        'log': buffer.getvalue(),
    }


if __name__ == '__main__':
    print(json.dumps(main(sys.argv.pop())))
