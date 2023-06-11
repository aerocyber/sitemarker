from gi.repository import Adw
from gi.repository import Gtk
from .data import Data
import pathlib
import sys
import json
import os
from .definitions import Definitions

from .error_window import ErrorWindow
from .notify_window import NotifyWindow

def printerr(*args):
    print(*args, file=sys.stderr)

def printinfo(*args):
    print(*args, file=sys.stdout)


@Gtk.Template(resource_path='/io/github/aerocyber/sitemarker/delete.ui')
class DeleteWindow(Adw.Window):
    __gtype_name__ = 'DeleteWindow'

    del_dropdown = Gtk.Template.Child()
    del_button_okay = Gtk.Template.Child()
    del_button_cancel = Gtk.Template.Child()


    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        definitions = Definitions()
        data_dir = definitions.data_dir()

        self.data_path = definitions.data_path()
        self.data_api = Data(self.data_path)

        _err = self.data_api.read_from_db_file()
        if _err != None:
            if _err.length > 0 and (type(_err) is list):
                for i in _err:
                    printerr(i)
            else:
                printerr(_err)

        keys = self.data_api.db_api.db.keys()
        self.key_list = Gtk.StringList()

        for key in keys:
            self.key_list.append(key)

        self.del_dropdown.connect('notify::selected-item', self.on_to_del_selected)
        self.del_dropdown.props.model = self.key_list

        self.del_button_okay.connect('clicked', self.del_selected)
        self.del_button_cancel.connect('clicked', lambda del_button_cancel: self.destroy())

    def del_selected(self, widget):
        self.data_api.db_api.pop(str(self.selected_to_del))

        keys = self.data_api.db_api.db.keys()
        self.key_list = Gtk.StringList()
        for key in keys:
            self.key_list.append(key)

        self.data_api.save_db()

        _err = self.data_api.read_from_db_file()
        if _err != None:
            if len(_err) > 0 and (type(_err) is list):
                for i in _err:
                    printerr(i)
            else:
                printerr(_err)

        _tmp_win = Adw.Window()
        info_window = NotifyWindow(transient_for=self, message=f"{self.selected_to_del} has been successfully deleted and the records saved locally.")
        info_window.show()
        self.destroy()

    def on_to_del_selected(self, dropdown, _):
        # Selected Gtk.StringObject
        selected = dropdown.props.selected_item
        if selected is not None:
            self.selected_to_del = selected.props.string

