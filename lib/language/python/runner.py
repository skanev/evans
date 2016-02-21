import imp
import io
import json
import os
import sys
import unittest
import traceback
import multiprocessing

TEST_PROCESS_TIMEOUT = 2  # in seconds.


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


def timeoutable(func):
    """Run a test in a process with a timeout.

    This decorator will spawn a process and run the given function using
    the args, kwargs and raise `TimeoutError` if the
    `TEST_PROCESS_TIMEOUT` (in seconds) is exceeded.

    Both the result and exceptions are being passed through a pipe.
    """

    def thread(*args, **kwargs):

        def runner(*args, **kwargs):
            conn = kwargs.pop('_conn')
            try:
                result = func(*args, **kwargs)
                conn.send(result)
            except Exception as e:
                conn.send(e)

        read_conn, write_conn = multiprocessing.Pipe()
        kwargs['_conn'] = write_conn
        test_process = multiprocessing.Process(
            target=runner, args=args, kwargs=kwargs)
        test_process.start()
        test_process.join(TEST_PROCESS_TIMEOUT)

        if test_process.is_alive():
            test_process.terminate()
            raise TimeoutError
        else:
            result = read_conn.recv()
            if isinstance(result, Exception):
                raise result

            return result
    return thread


class DiligentTestSuite(unittest.TestSuite):
    def __init__(self, tests=()):
        super().__init__()
        tests = [test for test in tests]
        for index, test in enumerate(tests):
            try:
                test_method = getattr(test, test._testMethodName)
                setattr(tests[index],
                        test._testMethodName,
                        timeoutable(test_method))
            except AttributeError:
                pass

        self.addTests(tests)

    def _removeTestAtIndex(self, index):
        """Just to avoid our suite doing that..."""


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
            loaded_test = imp.load_source('test', test_module)
            result = unittest.main(
                module=loaded_test,
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
    initial_niceness = os.nice(0)
    os.nice(10 - initial_niceness)
    print(json.dumps(main(sys.argv.pop())))
