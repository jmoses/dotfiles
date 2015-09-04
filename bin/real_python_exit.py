import sys
class FakeExit(object):
    def __repr__(*args, **kwargs):
        """
        Fuck you
        """
        sys.exit(0)

exit = FakeExit()
