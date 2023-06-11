from gi.repository import Adw
from gi.repository import Gtk
from .data import Data
import pathlib
import sys
from .definitions import Definitions

from .error_window import ErrorWindow

def printerr(*args):
    print(*args, file=sys.stderr)

def printinfo(*args):
    print(*args, file=sys.stdout)


@Gtk.Template(resource_path='/io/github/aerocyber/sitemarker/view-omio.ui')
class ViewOmioWindow(Adw.Window):
    __gtype_name__ = 'ViewOmioWindow'

    list_view = Gtk.Template.Child()

    def __init__(self, data_path: str, **kwargs):
        super().__init__(**kwargs)

        self.data_path = data_path
        if not pathlib.Path.exists(pathlib.Path(self.data_path)):
            err_win = ErrorWindow(message=f"{self.data_path} does not exist.")
            err_win.show()
            return

        self.data_api = Data(self.data_path)

        _err = self.data_api.read_from_db_file()
        if _err != None:
            if len(_err) > 0 and (type(_err) is list):
                for i in _err:
                    printerr(i)
            else:
                printerr(_err)

        self.records = self.data_api.get_all()

        for key in self.records.keys():
            record_list_box = Gtk.ListBoxRow()

            content_box = Gtk.Box()
            content_box.set_orientation(Gtk.Orientation.HORIZONTAL)

            info_box = Gtk.Box()
            info_box.set_margin_start(20)
            info_box.set_margin_end(20)
            info_box.set_margin_top(10)
            info_box.set_margin_bottom(10)
            info_box.set_spacing(10)
            info_box.set_orientation(Gtk.Orientation.VERTICAL)

            info_key = Gtk.Label()
            info_key.set_label(key)
            info_key.set_wrap(True)
            info_key.set_wrap_mode(Gtk.WrapMode.CHAR)
            info_box.append(info_key)

            info_url = Gtk.Label()
            info_url.set_label(self.records[key]["URL"])
            info_url.set_wrap(True)
            info_url.set_wrap_mode(Gtk.WrapMode.CHAR)
            info_box.append(info_url)

            cat = ""
            for _cat in self.records[key]["Categories"]:
                cat += _cat
                if self.records[key]["Categories"].index(_cat) + 1 != len(self.records[key]["Categories"]):
                    cat += ', '

            info_cat = Gtk.Label()
            info_cat.set_label(cat)
            info_cat.set_wrap(True)
            info_cat.set_wrap_mode(Gtk.WrapMode.CHAR)
            info_box.append(info_cat)

            action_box = Gtk.Box()
            action_box.set_margin_start(20)
            action_box.set_margin_end(20)
            action_box.set_margin_top(10)
            action_box.set_margin_bottom(10)
            action_box.set_spacing(10)
            action_box.set_orientation(Gtk.Orientation.VERTICAL)

            accept_btn = Gtk.Button()
            accept_btn.set_label(_("Open in Default Browser"))
            accept_btn.connect('clicked', lambda accept_btn: webbrowser.open_new_tab(self.records[key]["URL"]))
            action_box.append(accept_btn)

            copy_btn = Gtk.Button()
            copy_btn.set_label(_("Copy URL"))
            copy_btn.connect('clicked', lambda copy_btn: self.copy2clipboard(self.records[key]["URL"]))
            action_box.append(copy_btn)


            content_box.append(info_box)
            content_box.append(action_box)
            record_list_box.set_child(content_box)
            self.list_view.append(record_list_box)
