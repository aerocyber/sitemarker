from gi.repository import Adw
from gi.repository import Gtk
from . import ospyata as osmata
from .ospyata import OspyataException
import json
import sys
from .definitions import Definitions


from .error_window import ErrorWindow


def printerr(*args):
    print(*args, file=sys.stderr)

def printinfo(*args):
    print(*args, file=sys.stdout)

@Gtk.Template(resource_path='/io/github/aerocyber/sitemarker/add.ui')
class AddWindow(Adw.Window):
    __gtype_name__ = 'AddWindow'

    add_entry_name = Gtk.Template.Child()
    add_entry_url = Gtk.Template.Child()
    add_category_content_area = Gtk.Template.Child()
    add_button_okay = Gtk.Template.Child()
    add_button_cancel = Gtk.Template.Child()

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        definitions = Definitions()
        self.data_path = definitions.data_path()
        self.db_api = osmata.Osmata()
        self.add_button_okay.connect('clicked', self.add_record)
        self.add_button_cancel.connect('clicked', lambda add_button_cancel: self.destroy())

        internal_db_fp = open(str(self.data_path), 'r')
        _internal_db = json.load(internal_db_fp)
        internal_db_fp.close()

        _validator_omio = self.db_api.validate_omio(json.dumps(_internal_db))

        if not _validator_omio:
            # super.err_window(err_title="Invalid Internal DB", err_msg="The internal database is corrupt. Reset it.")
            _err_win = ErrorWindow(transient_for=self)
            _err_win.show()

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

    def add_record(self, add_button_okay):

        # Add the record to db
        name = self.add_entry_name.get_text()
        url = self.add_entry_url.get_text()
        categories_buffer = self.add_category_content_area.get_buffer()

        start_iter = categories_buffer.get_start_iter()
        end_iter = categories_buffer.get_end_iter()
        categories = categories_buffer.get_text(start_iter, end_iter, False).split(',')

        for i in range(len(categories)):
            categories[i] = categories[i].lstrip(' ')
            categories[i] = categories[i].rstrip(' ')
            categories[i] = categories[i].lstrip('\t')
            categories[i] = categories[i].rstrip('\t')

        if not name:
            _dialog_no_name = ErrorWindow(transient_for=self, message="No name has been entered")
            _dialog_no_name.show()
            return

        # URL
        _is_valid = True

        if name and (not url):
            _dialog_no_url = ErrorWindow(transient_for=self, message="No URL has been entered")
            _dialog_no_url.show()
            return

        try:
            _is_valid = self.db_api.validate_url(url)
        except Exception as e:
            _is_valid = False

        if name and url and (not _is_valid):
            _dialog_invalid_url = ErrorWindow(transient_for=self, message="Entered URL is invalid")
            _dialog_invalid_url.show()
            return

        # Categories
        if len(categories) == 0:
            categories = []

        _records = json.loads(self.db_api.dumpOmio())
        found = 0
        for key in _records:
            if key == name:
                found = 1
                name_exists_dialog = ErrorWindow(transient_for=self, message="Record with provided name is already present in DB.")
                name_exists_dialog.show()
                return
            if _records[key]["URL"] == url:
                found = 2
                url_exists_dialog = ErrorWindow(transient_for=self, message="Record with provided URL is already present in DB.")
                url_exists_dialog.show()
                return
        if found == 0:
            if not (name == '' or url == ''):
                self.db_api.push(name, url, categories)
                self.save_records()
                self.destroy()
    def save_records(self):
        # Save the records.

        # We are replacing the existing database.
        # This is by design because as new data is being entered,
        # the old database becomes outdated.
        f = open(str(self.data_path), 'w')
        f.write(self.db_api.dumpOmio())
        f.close()
