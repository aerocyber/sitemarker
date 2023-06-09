# MIT License
#
# Copyright (c) 2023 Aero
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# SPDX-License-Identifier: MIT

from gi.repository import Adw
from gi.repository import Gtk
from gi.repository import Gio
from gi.repository import GLib
from gi.repository import Gdk
from gi.repository import Pango
from urllib.parse import unquote
import datetime
import pathlib
import sys
import json
import webbrowser
import os
from .definitions import Definitions
from .data import Data
from . import ospyata as osmata

from .add import AddWindow
from .delete import DeleteWindow
from .error_window import ErrorWindow
from .view import ViewWindow
from .view_omio import ViewOmioWindow
from .notify_window import NotifyWindow


def printerr(*args):
    print(*args, file=sys.stderr)

def printinfo(*args):
    print(*args, file=sys.stdout)


@Gtk.Template(resource_path='/io/github/aerocyber/sitemarker/window.ui')
class SitemarkerWindow(Adw.ApplicationWindow):
    __gtype_name__ = 'SitemarkerWindow'

    add_record = Gtk.Template.Child()
    view_records = Gtk.Template.Child()
    del_record = Gtk.Template.Child()
    import_record = Gtk.Template.Child()
    export_record = Gtk.Template.Child()
    view_omio = Gtk.Template.Child()

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.create_action('add', self.on_add_action)
        self.create_action('del', self.on_del_action)
        self.create_action('view', self.on_view_action)
        self.create_action('view-omio', self.on_view_omio_action)
        self.create_action('import', self.on_import_action)
        self.create_action('export', self.on_export_action)
        self.create_action('docs', self.on_docs_action)

        self.import_record.connect("clicked", self.on_import_action)
        self.export_record.connect("clicked", self.on_export_action)
        self.view_omio.connect("clicked", self.on_view_omio_action)

        definitions = Definitions()
        data_dir = definitions.data_dir()

        # Check if DB exist in application's default (data) location
        # The dot in front of sitemarker is because we want to create a hidden directory
        # in *nix systems. It doesn't have any effect on Windows, but, the *nix
        # system has a default layout for $HOME. We don't want sitemarker to break that.
        if not os.getenv("XDG_DATA_HOME"):
            data_dir = pathlib.PurePath.joinpath(pathlib.Path.home(), '.local', 'share', 'sitemarker')
        else:
            data_dir = pathlib.PurePath.joinpath(pathlib.Path(os.getenv("XDG_DATA_HOME")), 'sitemarker')


        # The internal.omio file is just as valid as the original file.
        # This is by design because, if for some reason the application does not work
        # all of a sudden, we do not want the data to be unrecoverable.
        # Copying internal.omio file is just enough to get the data back.
        self.data_path = definitions.data_path()
        self.data_api = Data(self.data_path)

        if not pathlib.Path.exists(pathlib.Path(self.data_path)):
            pathlib.Path(str(data_dir)).mkdir(parents=True, exist_ok=True)
            f = open(str(self.data_path), 'w')
            f.write('{}')
            f.close()

        _err = self.data_api.read_from_db_file()
        if _err != None:
            if len(_err) > 0 and (type(_err) is list):
                for i in _err:
                    printerr(i)
            else:
                printerr(_err)


    def on_add_action(self, widget, _):
        add_win = AddWindow()
        add_win.show()

        _err = self.data_api.read_from_db_file()
        if _err != None:
            if len(_err) > 0 and (type(_err) is list):
                for i in _err:
                    printerr(i)
            else:
                printerr(_err)

    def on_docs_action(self, widget, _):
        webbrowser.open_new_tab("https://aerocyber.github.io/sitemarker")

    def on_view_action(self, widget, _):
        view_win = ViewWindow(transient_for=self)
        view_win.show()

    def on_del_action(self, widget, _):
        # Delete a record.
        del_win = DeleteWindow(transient_for=self)
        del_win.show()


        _err = self.data_api.read_from_db_file()
        if _err != None:
            if len(_err) > 0 and (type(_err) is list):
                for i in _err:
                    printerr(i)
            else:
                printerr(_err)

    def on_import_action(self, widget, _):
        # Import records.
        self.import_omio_fn()


        definitions = Definitions()
        data_dir = definitions.data_dir()

        internal_db_fp = open(str(self.data_path), 'r')
        _internal_db = json.load(internal_db_fp)
        internal_db_fp.close()
        _validator_omio = self.data_api.db_api.validate_omio(json.dumps(_internal_db))
        if not _validator_omio:
            err_window = ErrorWindow(transient_for=self, message="The internal database is corrupt.")
            err_window.show()

        _err = self.data_api.read_from_db_file()
        if _err != None:
            if _err.length > 0 and (type(_err) is list):
                for i in _err:
                    printerr(i)
            else:
                printerr(_err)


    def create_action(self, name, callback):
        """Add an application action.

        Args:
            name: the name of the action
            callback: the function to be called when the action is
              activated
            shortcuts: an optional list of accelerators
        """
        action = Gio.SimpleAction.new(name, None)
        action.connect("activate", callback)
        self.add_action(action)


    def save_records(self):
        # Save the records.

        # We are replacing the existing database.
        # This is by design because as new data is being entered,
        # the old database becomes outdated.
        f = open(str(self.data_path), 'w')
        f.write(self.db_api.dumpOmio())
        f.close()

    def on_view_omio_action(self, widget, _):
        # View omio file.
        print("Inside on_view_omio_action") # TODO: Remove after debugging
        self.view_db_as_file()

    def view_db_as_file(self):
        # File opening
        file_open_view_dialog = Gtk.FileDialog.new()
        file_open_view_dialog.set_accept_label("Open")

        file_filter = Gtk.FileFilter()
        file_filter.set_name("Osmata Importable Object File (OMIO File)")
        file_filter.add_pattern("*.omio")
        file_filters = Gio.ListStore.new(Gtk.FileFilter)
        file_filters.append(file_filter)
        file_open_view_dialog.set_filters(file_filters)

        file_open_view_dialog.set_modal(self)
        file_open_view_dialog.set_title("Choose a file to view")


        def open_response(file_open_view_dialog, result):

            ##### Credits of handle_filenames and clean_filenames: Curtail project
            ##### https://github.com/Huluti/Curtail/blob/ab0e268bbb4c30900daf30ff255db243baa82465/src/window.py

            def handle_filenames(filenames):
                def clean_filename(_filename):
                    if _filename.startswith('file://'):  # drag&drop
                        _filename = _filename[7:]  # remove 'file://'
                        _filename = unquote(_filename)  # remove %20
                        _filename = _filename.strip('\r\n\x00')  # remove spaces
                    return _filename
                filenames = [str(x) for x in filenames]
                _final_filenames = []
                # Clean filenames
                for __filename in filenames:
                    __filename = clean_filename(__filename)

                    path = pathlib.Path(filename)
                    if path.is_dir():
                        for new_filename in path.rglob("*"):
                            new_filename = clean_filename(str(new_filename))
                            _final_filenames.append(new_filename)
                    else:
                        _final_filenames.append(__filename)

                return _final_filenames

            try:
                file = file_open_view_dialog.open_finish(result)
            except GLib.Error as err:
                print("Could not open files: ", err.message)
            else:
                filename = file.get_uri()
                final_filenames = handle_filenames([filename])
                db = {}
                try:
                    _db = osmata.Osmata()
                    _db.loadOmio(final_filenames[0])
                except Exception:
                    printerr(f"Invalid file: {final_filenames[0]}")
                    err_window = ErrorWindow(transient_for=self, message="Invalid File")
                    err_window.show()
                    return

                view_dialog = ViewOmioWindow(transient_for=self, data_path=final_filenames[0])
                view_dialog.show()

        # file_open_view_dialog.open(view_dialog, None, open_response)
        file_open_view_dialog.open(self, None, open_response)

    def on_export_action(self, widget, _):
        # Import records.
        internal_db = self.data_api.db_api.dumpOmio()
        def export_db_as_file():
            file_save_export_dialog = Gtk.FileDialog.new()
            file_save_export_dialog.set_accept_label("Save as")
            file_filter = Gtk.FileFilter()
            file_filter.set_name("Osmata Importable Object File (OMIO File)")
            file_filter.add_pattern("*.omio")
            file_filters = Gio.ListStore.new(Gtk.FileFilter)
            file_filters.append(file_filter)
            file_save_export_dialog.set_filters(file_filters)
            default_name = "SiteMarker-export-" + datetime.date.today().strftime("%Y-%m-%d") + '-' +\
                           datetime.datetime.now().strftime("%H-%M-%S") + '.omio'
            file_save_export_dialog.set_initial_name(default_name)
            file_save_export_dialog.set_modal(self)
            file_save_export_dialog.set_title("Choose a file to export to")

            def save_response(file_save_export_dialog, result):
                ##### Credits of handle_filenames and clean_filenames: Curtail project
                ##### https://github.com/Huluti/Curtail/blob/ab0e268bbb4c30900daf30ff255db243baa82465/src/window.py
                def handle_filenames(filenames):
                    def clean_filename(_filename):
                        if _filename.startswith('file://'):  # drag&drop
                            _filename = _filename[7:]  # remove 'file://'
                            _filename = unquote(_filename)  # remove %20
                            _filename = _filename.strip('\r\n\x00')  # remove spaces
                        return _filename
                    filenames = [str(x) for x in filenames]
                    _final_filenames = []
                    # Clean filenames
                    for __filename in filenames:
                        __filename = clean_filename(__filename)

                        path = pathlib.Path(filename)
                        if path.is_dir():
                            for new_filename in path.rglob("*"):
                                new_filename = clean_filename(str(new_filename))
                                _final_filenames.append(new_filename)
                        else:
                            _final_filenames.append(__filename)

                    return _final_filenames

                try:
                    file = file_save_export_dialog.save_finish(result)
                except GLib.Error as err:
                    print("Could not open files: ", err.message)
                    err_win = ErrorWindow(transient_for=self, message=f"Could not open files: {err.message}")
                    err_win.show()
                else:
                    filename = file.get_uri()
                    final_filenames = handle_filenames([filename])
                    f = open(final_filenames[0], 'w')
                    f.write(internal_db)
                    f.close()
                    info_win = NotifyWindow(transient_for=self, message="Exported database.")
                    info_win.show()

            file_save_export_dialog.save(self, None, save_response)
        export_db_as_file()

    def import_omio_fn(self):
        # File opening
        file_open_view_dialog = Gtk.FileDialog.new()
        file_open_view_dialog.set_accept_label("Open")

        file_filter = Gtk.FileFilter()
        file_filter.set_name("Osmata Importable Object File (OMIO File)")
        file_filter.add_pattern("*.omio")
        file_filters = Gio.ListStore.new(Gtk.FileFilter)
        file_filters.append(file_filter)
        file_open_view_dialog.set_filters(file_filters)

        file_open_view_dialog.set_modal(self)
        file_open_view_dialog.set_title("Choose a file to view")


        def open_response(file_open_view_dialog, result):

            ##### Credits of handle_filenames and clean_filenames: Curtail project
            ##### https://github.com/Huluti/Curtail/blob/ab0e268bbb4c30900daf30ff255db243baa82465/src/window.py

            def handle_filenames(filenames):
                def clean_filename(_filename):
                    if _filename.startswith('file://'):  # drag&drop
                        _filename = _filename[7:]  # remove 'file://'
                        _filename = unquote(_filename)  # remove %20
                        _filename = _filename.strip(r'\r\n\x00')  # remove spaces
                    return _filename
                filenames = [str(x) for x in filenames]
                _final_filenames = []
                # Clean filenames
                for __filename in filenames:
                    __filename = clean_filename(__filename)

                    path = pathlib.Path(filename)
                    if path.is_dir():
                        for new_filename in path.rglob("*"):
                            new_filename = clean_filename(str(new_filename))
                            _final_filenames.append(new_filename)
                    else:
                        _final_filenames.append(__filename)

                return _final_filenames

            try:
                file = file_open_view_dialog.open_finish(result)
            except GLib.Error as err:
                print("Could not open files: ", err.message)
                err_win = ErrorWindow(transient_for=self, message=f"Could not open files: {err.message}")
                err_win.show()
            else:
                filename = file.get_uri()
                final_filenames = handle_filenames([filename])
                db = {}
                try:
                    db = osmata.Osmata().loadOmio(final_filenames[0])
                except Exception:
                    printerr("Invalid file")
                    err_window = ErrorWindow(transient_for=self, message="Invalid File")
                    err_window.show()
                    return


                view_dialog = Adw.Window()
                view_dialog.set_transient_for(self)
                view_dialog.set_default_size(550, 400)
                view_dialog.set_title("Importing from " + final_filenames[0])

                view_box = Gtk.Box()
                view_box.set_orientation(Gtk.Orientation.VERTICAL)
                view_box.append(Adw.HeaderBar())
                view_dialog.set_content(view_box)
                view_box.append(
                    Gtk.Label(
                        label="The following records have either their keys or URLs in the internal DB and are not imported.",
                        margin_start = 10,
                        margin_end = 10,
                        margin_top = 20,
                        margin_bottom = 20,
                        wrap = True,
                        wrap_mode = Pango.WrapMode.CHAR
                    )
                )
                scroll_box = Gtk.ScrolledWindow()
                scroll_box.set_margin_top(10)
                scroll_box.set_margin_bottom(10)
                scroll_box.set_margin_start(10)
                scroll_box.set_margin_end(10)
                scroll_box.set_max_content_height(500)
                scroll_box.set_min_content_height(400)
                scroll_box.set_max_content_width(200)
                scroll_box.set_min_content_width(100)
                view_box.append(scroll_box)

                view_records_list_box = Gtk.ListBox.new()

                for key in db.keys():
                    url = db[key]["URL"]
                    tags = db[key]["Categories"]
                    f = False # Is it found in db?

                    for int_key in self.data_api.db_api.db:
                        int_url = self.data_api.db_api.db[int_key]["URL"]
                        column = Gtk.Box()
                        column.set_orientation(Gtk.Orientation.HORIZONTAL)
                        column.set_margin_start(10)
                        column.set_margin_end(10)
                        column.set_margin_top(20)
                        column.set_margin_bottom(20)
                        column.set_spacing(50)

                        data_box = Gtk.Box()
                        data_box.set_margin_start(10)
                        data_box.set_margin_end(10)
                        data_box.set_margin_top(10)
                        data_box.set_margin_bottom(10)
                        data_box.set_spacing(10)
                        data_box.set_orientation(Gtk.Orientation.VERTICAL)
                        data_box.set_spacing(10)

                        column.append(data_box)

                        if (int_key == key) or (int_url == url):
                            _name_item = Gtk.Label()
                            _name_item.set_wrap(True)
                            _name_item.set_wrap_mode(Pango.WrapMode.WORD)
                            _name_item.set_label(key)

                            f = True

                            _url_item = Gtk.Label()
                            _url_item.set_wrap(True)
                            _url_item.set_wrap_mode(Pango.WrapMode.CHAR)
                            _url_item.set_label(url)

                            _categories_item = Gtk.Label()
                            _categories_item.set_wrap(True)
                            _categories_item.set_wrap_mode(Pango.WrapMode.WORD)
                            _cats = "Applied tags: "
                            for i in tags:
                                _cats += i
                                if len(tags) != tags.index(i) + 1:
                                    _cats += ", "
                                _categories_item.set_label(_cats)
                            if (_name_item not in column) or (_url_item not in column):
                                column.append(_name_item)
                                column.append(_url_item)
                                column.append(_categories_item)
                                view_records_list_box.append(column)
                    if not f:
                        self.data_api.db_api.push(key, url, tags)
                        self.data_api.save_db()

                scroll_box.set_child(view_records_list_box)
                view_dialog.show()

        # file_open_view_dialog.open(view_dialog, None, open_response)
        file_open_view_dialog.open(self, None, open_response)
