from gi.repository import Adw
from gi.repository import Gtk


class WidgetsConnector:
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

    def add_record_dialog(self):
        add_dialog = Gtk.NativeDialog()

        add_box = Gtk.Box()
        add_box.set_orientation(Gtk.Orientation.VERTICAL)
        add_dialog.set_child(add_box)
        add_dialog.set_default_size(600,250)

        # The layout of the add_box

        # Name
        add_box_name = Gtk.Box()
        add_box_name.set_orientation(Gtk.Orientation.HORIZONTAL)

        add_label_name = Gtk.Label("Name of the record")

        add_box_name.append(add_label_name)

        add_entry_name = Gtk.Entry()
