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
from . import ospyata as osmata
from urllib.parse import unquote
from .ospyata import OspyataException
import datetime
import pathlib
import sys
import json
import webbrowser


def printerr(*args):
    print(*args, file=sys.stderr)


@Gtk.Template(resource_path='/io/github/aerocyber/sitemarker/window.ui')
class SitemarkerWindow(Adw.ApplicationWindow):
    __gtype_name__ = 'SitemarkerWindow'

    add_record = Gtk.Template.Child()
    view_records = Gtk.Template.Child()
    del_record = Gtk.Template.Child()
    view_omio_file_records = Gtk.Template.Child()
    import_omio_file_records = Gtk.Template.Child()
    export_omio_file_records = Gtk.Template.Child()

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.create_action('add', self.on_add_action)
        self.create_action('del', self.on_del_action)
        self.create_action('view', self.on_view_action)
        self.create_action('view-omio', self.on_view_omio_action)
        self.create_action('import', self.on_import_action)
        self.create_action('export', self.on_export_action)

        # The DB interface
        self.db_api = osmata.Osmata()

        # Check if DB exist in application's default (data) location
        # The dot in front of sitemarker is because we want to create a hidden directory
        # in *nix systems. It doesn't have any effect on Windows, but, the *nix
        # system has a default layout for $HOME. We don't want sitemarker to break that.
        data_dir = pathlib.PurePath.joinpath(pathlib.Path.home(), '.sitemarker')
        # The internal.omio file is just as valid as the original file.
        # This is by design because, if for some reason the application does not work
        # all of a sudden, we do not want the data to be unrecoverable.
        # Copying internal.omio file is just enough to get the data back.
        self.data_path = pathlib.PurePath.joinpath(data_dir, 'internal.omio')
        if not pathlib.Path.exists(self.data_path):
            pathlib.Path(data_dir).mkdir(parents=True, exist_ok=True)
            f = open(str(self.data_path), 'w')
            f.write('{}')
            f.close()

        internal_db_fp = open(str(self.data_path), 'r')
        _internal_db = json.load(internal_db_fp)
        internal_db_fp.close()
        _validator_omio = self.db_api.validate_omio(json.dumps(_internal_db))
        if not _validator_omio:
            self.err_window(err_title="Invalid Internal DB", err_msg="The internal database is corrupt. Reset")
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


    def on_add_action(self, widget, _):
        # The Add action dialog box

        # The Window is the central part of this section.
        # It is supposed to contain all the other widgets.
        self.add_dialog = Adw.Window()
        self.add_dialog.set_transient_for(self) # For making it a modal above the main Application Window
        self.add_dialog.set_default_size(550, 400) # Default size

        # The box that has it all. All child widgets are made under this box.
        # This box is made the child of the Window
        add_dialog_box = Gtk.Box()
        # We don't want a cursed ui now, do we?
        # Gtk.Orientation.VERTICAL places each items vertically and the
        # set_orientation is used to set this behaviour to the Window.
        add_dialog_box.set_orientation(Gtk.Orientation.VERTICAL)

        add_header = Adw.HeaderBar() # Our header bar
        self.add_dialog.set_title("Add a record")
        add_dialog_box.append(add_header) # HeaderBar into the container

        self.add_dialog.set_content(add_dialog_box) # The content of the Window is the container box.

        # The add_box is where the layout is actually gonna go.
        # This is again, appended to the add_dialog_box
        add_box = Gtk.Box()
        add_box.set_orientation(Gtk.Orientation.VERTICAL) # Vertical alignment... again.
        add_box.set_margin_start(20)
        add_box.set_margin_end(20)
        add_box.set_margin_top(20)
        add_box.set_margin_bottom(20)
        add_dialog_box.append(add_box) # Add the box to the main box.

        # The layout of the add_box

        # Name
        add_box_name = Gtk.Box()
        add_box_name.set_margin_top(20)
        add_box_name.set_margin_bottom(20)
        add_box_name.set_orientation(Gtk.Orientation.HORIZONTAL)
        add_box_name.set_spacing(10)

        add_label_name = Gtk.Label()
        add_label_name.set_text("Name")
        add_box_name.append(add_label_name)

        self.add_entry_name = Gtk.Entry()
        self.add_entry_name.set_alignment(0.01)
        self.add_entry_name.set_input_hints(Gtk.InputHints.SPELLCHECK)
        self.add_entry_name.set_placeholder_text("Enter the Name")
        self.add_entry_name.set_max_width_chars(100)
        add_box_name.append(self.add_entry_name)

        add_box.append(add_box_name)

        # URL
        add_box_url = Gtk.Box()
        add_box_url.set_margin_top(20)
        add_box_url.set_margin_bottom(20)
        add_box_url.set_orientation(Gtk.Orientation.HORIZONTAL)

        add_label_url = Gtk.Label()
        add_label_url.set_text("URL")
        add_box_url.append(add_label_url)
        add_box_url.set_spacing(20)

        self.add_entry_url = Gtk.Entry()
        self.add_entry_url.set_alignment(0.01)
        self.add_entry_url.set_max_width_chars(100)
        self.add_entry_url.set_placeholder_text("Enter the URL")
        self.add_entry_url.set_input_hints(Gtk.InputHints.LOWERCASE)
        add_box_url.append(self.add_entry_url)

        add_box.append(add_box_url)

        # Categories
        add_box_categories = Gtk.Box()
        add_box_categories.set_orientation(Gtk.Orientation.VERTICAL)

        add_label_category = Gtk.Label()
        add_label_category.set_text("Tags. Separate them with comma(s).")
        add_box_categories.append(add_label_category)
        add_box_categories.set_spacing(10)

        # Before going to the content area, a scrolling area is defined to contain it.
        # So that users can scroll, if there are a lot of categories, even when
        # it isn't going to happen. But hey! It's humans!
        add_category_scrolled_window = Gtk.ScrolledWindow.new()
        add_category_scrolled_window.set_max_content_height(300)
        add_category_scrolled_window.set_max_content_width(200)
        add_category_scrolled_window.set_min_content_height(200)
        add_category_scrolled_window.set_min_content_width(100)
        add_category_scrolled_window.set_margin_start(10)
        add_category_scrolled_window.set_margin_end(10)

        self.add_category_content_area = Gtk.TextView()
        self.add_category_content_area.set_monospace(True)

        # All the category related addition
        add_category_scrolled_window.set_child(self.add_category_content_area)
        add_box_categories.append(add_category_scrolled_window)
        add_box.append(add_box_categories)

        # Buttons!

        # The Button container
        add_box_button = Gtk.Box()
        add_box_button.set_margin_top(20)
        add_box_button.set_margin_bottom(20)
        add_box_button.set_margin_start(200)
        add_box_button.set_margin_end(200)
        add_box_button.set_orientation(Gtk.Orientation.HORIZONTAL)
        add_box_button.set_spacing(10)
        add_dialog_box.append(add_box_button)

        # The Add button
        add_button_okay = Gtk.Button()
        add_button_okay.set_label("Add Record")
        add_box_button.append(add_button_okay)
        add_button_okay.connect('clicked', self.add_record)

        # The Cancel button
        add_button_cancel = Gtk.Button()
        add_button_cancel.set_label("Cancel")
        add_box_button.append(add_button_cancel)
        add_button_cancel.connect('clicked', lambda add_button_cancel: self.add_dialog.destroy())

        # Show it!
        self.add_dialog.show()

    def on_view_action(self, widget, _):
        # Update the code to view all records.
        print("View action triggered.")
        db = json.loads(self.db_api.dumpOmio())
        self.view_element(self, db=db)

    def on_del_action(self, widget, _):
        # Delete a record.
        keys = self.db_api.db.keys()
        self.del_win = Adw.Window(transient_for=self)
        self.del_win.set_default_size(400,300)
        self.del_win.set_title("Delete a record")

        del_box = Gtk.Box()
        del_box.set_orientation(Gtk.Orientation.VERTICAL) # Vertical alignment... again.
        self.del_win.set_content(del_box)
        del_box.append(Adw.HeaderBar())

        del_content_box = Gtk.Box()
        del_content_box.set_margin_start(40)
        del_content_box.set_margin_end(40)
        del_content_box.set_margin_top(50)
        del_content_box.set_margin_bottom(50)
        del_content_box.set_orientation(Gtk.Orientation.VERTICAL)
        del_content_box.set_spacing(50)
        del_box.append(del_content_box)

        # Saved by: https://rafaelmardojai.pages.gitlab.gnome.org/pygobject-guide/gtk4/controls/dropdown.html
        self.selected_to_del = ''
        del_dropdown = Gtk.DropDown()
        del_dropdown.connect('notify::selected-item', self.on_to_del_selected)
        del_content_box.append(del_dropdown)

        self.del_list = Gtk.StringList()
        del_dropdown.props.model = self.del_list

        for key in keys:
            self.del_list.append(key)

        del_btn = Gtk.Button()
        del_btn.set_label("Delete selected")
        del_btn.connect('clicked', self.del_selected)
        del_content_box.append(del_btn)

        self.del_win.show()

    def del_selected(self, widget):
        self.db_api.pop(str(self.selected_to_del))
        self.del_win.destroy()
        keys = self.db_api.db.keys()
        for key in keys:
            self.del_list.append(key)
        self.save_records()
        _tmp_win = Adw.Window()
        self.err_window(err_title="Deleted successfully", err_msg=f"{self.selected_to_del} has been successfully deleted and the records saved locally.")

    def on_to_del_selected(self, dropdown, _):
        # Selected Gtk.StringObject
        selected = dropdown.props.selected_item
        if selected is not None:
            self.selected_to_del = selected.props.string

    def on_import_action(self, widget, _):
        # Import records.
        self.import_omio_fn()


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
            _dialog_no_name = Adw.Window(transient_for=self.add_dialog)
            _dialog_no_name.set_default_size(width=int(1366 / 5), height=int(768 / 3))
            _dialog_no_name.set_size_request(width=int(1366 / 5), height=int(768 / 3))
            _dialog_no_name.set_title("Error")
            _dialog_no_name.set_modal(True)
            _dialog_no_name_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
            _dialog_no_name.set_content(_dialog_no_name_box)

            _dialog_no_name_box.append(Adw.HeaderBar())

            _dialog_no_name_box.append(
                Gtk.Label(label="No name has been entered", margin_bottom=int(768 / 6), margin_end=10,
                          margin_start=10, margin_top=int(768 / 6)))
            _dialog_no_name.show()
            return

        # URL
        _is_valid = True

        if name and (not url):
            _dialog_no_url = Adw.Window(transient_for=self.add_dialog)
            _dialog_no_url.set_default_size(width=int(1366 / 5), height=int(768 / 3))
            _dialog_no_url.set_size_request(width=int(1366 / 5), height=int(768 / 3))
            _dialog_no_url.set_title("Error")
            _dialog_no_url.set_modal(True)
            _dialog_no_url_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
            _dialog_no_url.set_content(_dialog_no_url_box)

            _dialog_no_url_box.append(Adw.HeaderBar())

            _dialog_no_url_box.append(
                Gtk.Label(label="No url has been entered", margin_bottom=int(768 / 6), margin_end=10,
                          margin_start=10, margin_top=int(768 / 6)))
            _dialog_no_url.show()
            return

        try:
            _is_valid = self.db_api.validate_url(url)
        except Exception as e:
            _is_valid = False

        if name and url and (not _is_valid):
            _dialog_invalid_url = Adw.Window(transient_for=self.add_dialog)
            _dialog_invalid_url.set_default_size(width=int(1366 / 5), height=int(768 / 3))
            _dialog_invalid_url.set_size_request(width=int(1366 / 5), height=int(768 / 3))
            _dialog_invalid_url.set_title("Error")
            _dialog_invalid_url.set_modal(True)
            _dialog_invalid_url_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
            _dialog_invalid_url.set_content(_dialog_invalid_url_box)
            _dialog_invalid_url_box.append(Adw.HeaderBar())
            _dialog_invalid_url_box.append(
                Gtk.Label(label="Entered URL is invalid", margin_bottom=int(768 / 6), margin_end=10,
                          margin_start=10, margin_top=int(768 / 6)))
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
                name_exists_dialog = Adw.Window(transient_for=self)
                name_exists_dialog.set_modal(True)

                no_name_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
                name_exists_dialog.set_content(no_name_box)
                name_exists_dialog.set_title("Error")
                no_name_box.append(Adw.HeaderBar())
                name_exists_dialog.set_default_size(width=int(1366 / 5), height=int(768 / 3))
                name_exists_dialog.set_size_request(width=int(1366 / 5), height=int(768 / 3))
                no_name_box.append(Gtk.Label(label="Record with provided Name is already present in DB.",
                                             margin_top=10, margin_start=10, margin_end=10, margin_bottom=10))
                name_exists_dialog.set_modal(True)
                name_exists_dialog.show()
                return
            if _records[key]["URL"] == url:
                found = 2
                url_exists_dialog = Adw.Window(transient_for=self)
                url_exists_dialog.set_modal(True)
                no_url_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
                url_exists_dialog.set_content(no_url_box)
                no_url_box.append(Adw.HeaderBar())
                url_exists_dialog.set_title("Error")
                url_exists_dialog.set_default_size(width=int(1366 / 5), height=int(768 / 3))
                url_exists_dialog.set_size_request(width=int(1366 / 5), height=int(768 / 3))
                no_url_box.append(Gtk.Label(label="Record with provided URL is already present in DB.",
                                            margin_top=10, margin_start=10, margin_end=10, margin_bottom=10))
                url_exists_dialog.set_modal(True)
                url_exists_dialog.show()
                return
        if found == 0:
            if not (name == '' or url == ''):
                self.db_api.push(name, url, categories)
                self.save_records()
                self.add_dialog.destroy()


    def err_window(self, err_title="Error", err_msg="Sorry, internal error"):
        error_dialog = Adw.Window()
        error_dialog.set_default_size(
            height=int(768 / 3),
            width=int(1366 / 5)
        )
        error_dialog.set_transient_for(self)
        error_dialog.set_title(err_title)
        layout = Gtk.Box()
        layout.set_orientation(Gtk.Orientation.VERTICAL)
        layout.append(Adw.HeaderBar())
        # layout.set_margin_top(20)
        layout.set_margin_bottom(20)
        # layout.set_margin_start(10)
        # layout.set_margin_end(10)
        layout.append(
            Gtk.Label(label=err_msg,
            margin_top=int(1366 / 20),
            margin_start=10,
            margin_end=10,
            margin_bottom=20
            )
        )
        close_btn = Gtk.Button(label="Okay")
        close_btn.set_margin_top(10)
        close_btn.set_margin_bottom(10)
        close_btn.set_margin_start(10)
        close_btn.set_margin_end(10)
        close_btn.connect('clicked', lambda close_btn: error_dialog.close())
        layout.append(close_btn)
        error_dialog.set_content(layout)
        error_dialog.show()

    def view_element(self, widget, db, win_title="View Records"):
        # View all records from db.
        view_dialog = Adw.Window()
        view_dialog.set_transient_for(self)
        view_dialog.set_default_size(550, 400)
        view_dialog.set_title(win_title)

        view_box = Gtk.Box()
        view_box.set_orientation(Gtk.Orientation.VERTICAL)
        view_box.append(Adw.HeaderBar())
        view_dialog.set_content(view_box)

        view_records_list_box = Gtk.ListBox.new()

        for key in db.keys():
            url = db[key]["URL"]
            tags = db[key]["Categories"]


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

            _name_item = Gtk.Label()
            _name_item.set_label(key)

            _url_item = Gtk.Label()
            _url_item.set_label(url)

            _categories_item = Gtk.Label()
            _cats = "Applied tags: "
            for i in tags:
                _cats += i
                if len(tags) != tags.index(i) + 1:
                    _cats += ", "
            _categories_item.set_label(_cats)

            data_box.append(_name_item)
            data_box.append(_url_item)
            data_box.append(_categories_item)

            control_box = Gtk.Box()
            control_box.set_margin_start(10)
            control_box.set_margin_end(10)
            control_box.set_margin_top(10)
            control_box.set_margin_bottom(10)
            control_box.set_orientation(Gtk.Orientation.VERTICAL)
            control_box.set_spacing(10)

            open_in_browser = Gtk.Button()
            open_in_browser.set_label("Open in Browser")
            open_in_browser.connect("clicked", lambda open_in_browser: webbrowser.open_new_tab(url))
            control_box.append(open_in_browser)

            copy_ = Gtk.Button()
            copy_.set_label("Copy to Clipboard")
            copy_.connect("clicked", lambda copy_: self.copy2clipboard(url))
            control_box.append(copy_)

            column.append(data_box)
            column.append(control_box)
            view_records_list_box.append(column)

        view_box.append(view_records_list_box)
        view_dialog.show()

    def get_clipboard(self):
        clipboard = Gdk.Display().get_default().get_clipboard()
        return clipboard

    def copy2clipboard(self, text: str):
        _clipboard = self.get_clipboard()
        _clipboard.set(text)

    def on_view_omio_action(self, widget, _):
        # View omio file.
        print("View omio file content action triggered.")
        self.view_db_as_file()

    def view_db_as_file(self):
        # File opening
        print("File opening for reading.")
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
                    db = osmata.Osmata().loadOmio(final_filenames[0])
                except Exception:
                    printerr("Invalid file")
                    self.err_window(err_title="Error", err_msg="Invalid File")
                    return


                view_dialog = Adw.Window()
                view_dialog.set_transient_for(self)
                view_dialog.set_default_size(550, 400)
                view_dialog.set_title("Records in " + final_filenames[0])

                view_box = Gtk.Box()
                view_box.set_orientation(Gtk.Orientation.VERTICAL)
                view_box.append(Adw.HeaderBar())
                view_dialog.set_content(view_box)

                view_records_list_box = Gtk.ListBox.new()

                for key in db.keys():
                    url = db[key]["URL"]
                    tags = db[key]["Categories"]


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

                    _name_item = Gtk.Label()
                    _name_item.set_label(key)

                    _url_item = Gtk.Label()
                    _url_item.set_label(url)

                    _categories_item = Gtk.Label()
                    _cats = "Applied tags: "
                    for i in tags:
                        _cats += i
                        if len(tags) != tags.index(i) + 1:
                            _cats += ", "
                    _categories_item.set_label(_cats)

                    data_box.append(_name_item)
                    data_box.append(_url_item)
                    data_box.append(_categories_item)

                    control_box = Gtk.Box()
                    control_box.set_margin_start(10)
                    control_box.set_margin_end(10)
                    control_box.set_margin_top(10)
                    control_box.set_margin_bottom(10)
                    control_box.set_orientation(Gtk.Orientation.VERTICAL)
                    control_box.set_spacing(10)

                    open_in_browser = Gtk.Button()
                    open_in_browser.set_label("Open in Browser")
                    open_in_browser.connect("clicked", lambda open_in_browser: webbrowser.open_new_tab(url))
                    control_box.append(open_in_browser)

                    copy_ = Gtk.Button()
                    copy_.set_label("Copy to Clipboard")
                    copy_.connect("clicked", lambda copy_: self.copy2clipboard(url))
                    control_box.append(copy_)

                    column.append(data_box)
                    column.append(control_box)
                    view_records_list_box.append(column)

                view_box.append(view_records_list_box)
                view_dialog.show()

        # file_open_view_dialog.open(view_dialog, None, open_response)
        file_open_view_dialog.open(self, None, open_response)

    def on_export_action(self, widget, _):
        # Import records.
        print("Export records action triggered.")
        internal_db = self.db_api.dumpOmio()
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
                else:
                    filename = file.get_uri()
                    final_filenames = handle_filenames([filename])
                    f = open(final_filenames[0], 'w')
                    f.write(internal_db)
                    f.close()
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
                    db = osmata.Osmata().loadOmio(final_filenames[0])
                except Exception:
                    printerr("Invalid file")
                    self.err_window(err_title="Error", err_msg="Invalid File")
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
                    )
                )

                view_records_list_box = Gtk.ListBox.new()

                for key in db.keys():
                    url = db[key]["URL"]
                    tags = db[key]["Categories"]
                    f = False # Is it found in db?

                    for int_key in self.db_api.db:
                        int_url = self.db_api.db[int_key]["URL"]
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
                            _name_item.set_label(key)

                            f = True

                            _url_item = Gtk.Label()
                            _url_item.set_label(url)

                            _categories_item = Gtk.Label()
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
                        self.db_api.push(key, url, tags)
                        self.save_records()

                view_box.append(view_records_list_box)
                view_dialog.show()

        # file_open_view_dialog.open(view_dialog, None, open_response)
        file_open_view_dialog.open(self, None, open_response)
