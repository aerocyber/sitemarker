from gi.repository import Adw
from gi.repository import Gtk


def printerr(*args):
    print(*args, file=sys.stderr)

def printinfo(*args):
    print(*args, file=sys.stdout)

@Gtk.Template(resource_path='/io/github/aerocyber/sitemarker/error_window.ui')
class ErrorWindow(Adw.Window):
    __gtype_name__ = 'ErrorWindow'

    err_msg = Gtk.Template.Child()
    err_close = Gtk.Template.Child()

    def __init__(self, message, **kwargs):
        super().__init__(**kwargs)
        self.err_msg.set_text(message)
        self.err_close.connect('clicked', lambda err_close: self.destroy())
