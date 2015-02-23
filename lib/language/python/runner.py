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


def timeout(func):
    """This decorator will spawn a thread and run the given function
    using the args, kwargs and raise `TimeoutError` if the
    `timeout_duration` (in seconds) is exceeded.
    """
    timeout_duration = 2

    def thread(*args, **kwargs):
        class InterruptableThread(threading.Thread):
            def __init__(self):
                super().__init__()
                self.result = None
                self.exc_info = None

            def run(self):
                try:
                    self.result = func(*args, **kwargs)
                except:
                    self.exc_info = sys.exc_info()

        it = InterruptableThread()
        it.start()
        it.join(timeout_duration)
        if it.is_alive():
            it._stop()
            raise TimeoutError
        else:
            if it.exc_info:
                raise it.exc_info[1]
            return it.result
    return thread


class DiligentTestSuite(unittest.TestSuite):
    def __init__(self, tests=[]):
        tests = [test for test in tests]
        for index, test in enumerate(tests):
            try:
                test_method = getattr(test, test._testMethodName)
                setattr(tests[index], test._testMethodName, timeout(test_method))
            except AttributeError:
                pass
        super().__init__(tests)


class DiligentTestLoader(unittest.loader.TestLoader):
    suiteClass = DiligentTestSuite


class DiligentTextTestRunner(unittest.TextTestRunner):
    all_tests = []

    def run(self, test):
        result = super().run(test)
        for test_suite in test._tests:
            for test in test_suite._tests:
                self.all_tests.append(str(test))
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
                testRunner=DiligentTextTestRunner,
                testLoader=DiligentTestLoader(),
            ).result
        except Exception as e:
            result = EmptyTestResult()
            print(e)
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
