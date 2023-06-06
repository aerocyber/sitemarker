from gi.repository import Adw
from gi.repository import Gtk
from . import ospyata as osmata
from .ospyata import OspyataException
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
        self.db_api = osmata.Osmata()

        definitions = Definitions()
        data_dir = definitions.data_dir()


        # The internal.omio file is just as valid as the original file.
        # This is by design because, if for some reason the application does not work
        # all of a sudden, we do not want the data to be unrecoverable.
        # Copying internal.omio file is just enough to get the data back.
        self.data_path = definitions.data_path()

        internal_db_fp = open(str(self.data_path), 'r')
        _internal_db = json.load(internal_db_fp)
        internal_db_fp.close()
        _validator_omio = self.db_api.validate_omio(json.dumps(_internal_db))
        if not _validator_omio:
            err_window = ErrorWindow(transient_for=self, message="The internal database is corrupt.")
            err_window.show()
        internal_db = _internal_db
        # Adding data to the internal db is easy
        if internal_db != {}:
            # We don't want to load an empty db as sitemarker's initialization takes care of that.
            for key in internal_db.keys():
                try:
                    _name = key
                    _url = internal_db[key]["URL"]
                    _categories = internal_db[key]["Categories"]
                    self.db_api.push(_name, _url, _categories)
                except OspyataException:
                    # This library... loves throwing errors... We must handle it.
                    # Instead of suppressing it, we will print it to stderr.
                    # For now.
                    printerr(OspyataException)

        keys = self.db_api.db.keys()
        self.key_list = Gtk.StringList()

        for key in keys:
            self.key_list.append(key)

        self.del_dropdown.connect('notify::selected-item', self.on_to_del_selected)
        self.del_dropdown.props.model = self.key_list

        self.del_button_okay.connect('clicked', self.del_selected)
        self.del_button_cancel.connect('clicked', lambda del_button_cancel: self.destroy())

    def del_selected(self, widget):
        self.db_api.pop(str(self.selected_to_del))
        self.destroy()
        keys = self.db_api.db.keys()
        for key in keys:
            self.key_list.append(key)
        self.save_records()
        _tmp_win = Adw.Window()
        info_window = NotifyWindow(transient_for=self, message=f"{self.selected_to_del} has been successfully deleted and the records saved locally.")

    def on_to_del_selected(self, dropdown, _):
        # Selected Gtk.StringObject
        selected = dropdown.props.selected_item
        if selected is not None:
            self.selected_to_del = selected.props.string

    def save_records(self):
        # Save the records.

        # We are replacing the existing database.
        # This is by design because as new data is being entered,
        # the old database becomes outdated.
        f = open(str(self.data_path), 'w')
        f.write(self.db_api.dumpOmio())
        f.close()
