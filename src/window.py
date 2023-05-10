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


@Gtk.Template(resource_path='/com/github/aerocyber/osmata/window.ui')
class OsmataWindow(Adw.ApplicationWindow):
    __gtype_name__ = 'OsmataWindow'

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

    def on_add_action(self, widget, _):
        # TODO: Update the code to add new record.
        print("Add action triggered.")

        # The Window is the central part of this section.
        # It is supposed to contain all the other widgets.
        add_dialog = Adw.Window()
        add_dialog.set_transient_for(self) # For making it a modal above the main Application Window
        add_dialog.set_default_size(550, 400) # Default size

        # The box that has it all. All child widgets are made under this box.
        # This box is made the child of the Window
        add_dialog_box = Gtk.Box()
        # We don't want a cursed ui now, do we?
        # Gtk.Orientation.VERTICAL places each items vertically and the
        # set_orientation is used to set this behaviour to the Window.
        add_dialog_box.set_orientation(Gtk.Orientation.VERTICAL)

        add_header = Adw.HeaderBar() # Our header bar
        add_dialog_box.append(add_header) # HeaderBar into the container

        add_dialog.set_content(add_dialog_box) # The content of the Window is the container box.

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
        add_box_name.set_spacing(110)

        add_label_name = Gtk.Label()
        add_label_name.set_text("Name of the record")
        add_box_name.append(add_label_name)

        add_entry_name = Gtk.Entry()
        add_entry_name.set_alignment(0.01)
        add_entry_name.set_input_hints(Gtk.InputHints.SPELLCHECK)
        add_entry_name.set_placeholder_text("Enter the Name to be mapped")
        add_entry_name.set_max_width_chars(100)
        add_box_name.append(add_entry_name)

        add_box.append(add_box_name)

        # URL
        add_box_url = Gtk.Box()
        add_box_url.set_margin_top(20)
        add_box_url.set_margin_bottom(20)
        add_box_url.set_orientation(Gtk.Orientation.HORIZONTAL)

        add_label_url = Gtk.Label()
        add_label_url.set_text("URL to be associated in the record")
        add_box_url.append(add_label_url)
        add_box_url.set_spacing(20)

        add_entry_url = Gtk.Entry()
        add_entry_url.set_alignment(0.01)
        add_entry_url.set_max_width_chars(100)
        add_entry_url.set_placeholder_text("Enter the URL to be mapped")
        add_entry_url.set_input_hints(Gtk.InputHints.LOWERCASE)
        add_box_url.append(add_entry_url)

        add_box.append(add_box_url)

        # Categories
        add_box_categories = Gtk.Box()
        add_box_categories.set_orientation(Gtk.Orientation.HORIZONTAL)

        add_category_scrolled_window = Gtk.ScrolledWindow.new()
        add_category_scrolled_window.set_max_content_height(300)
        add_category_scrolled_window.set_max_content_height(200)
        add_category_scrolled_window.set_min_content_height(200)
        add_category_scrolled_window.set_min_content_height(100)
        add_category_scrolled_window.set_margin_start(10)
        add_category_scrolled_window.set_margin_end(10)

        add_box.append(add_category_scrolled_window)

        add_dialog.show()

    def on_view_action(self, widget, _):
        # TODO: Update the code to view all records.
        print("View action triggered.")

    def on_del_action(self, widget, _):
        # TODO: Update code to delete a record.
        print("Delete action triggered.")

    def on_view_omio_action(self, widget, _):
        # TODO: Update code to view omio file.
        print("View omio file content action triggered.")

    def get_contributors(self):
        return [
        ]
        # Append your names here, contributors!
        # Format: "Name url""

    def get_translators(self):
        return [
        ]
        # Append your name here, translators!
        # Format: "Name url"

    def on_import_action(self, widget, _):
        # TODO: Update code to import records.
        print("Import records action triggered.")

    def on_export_action(self, widget, _):
        # TODO: Update code to import records.
        print("Export records action triggered.")

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
