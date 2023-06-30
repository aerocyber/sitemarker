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

import sys
import gi

gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')

from gi.repository import Gtk, Gio, Adw, GLib
from .window import SitemarkerWindow


class SitemarkerApplication(Adw.Application):
    """The main application singleton class."""

    def __init__(self):
        super().__init__(application_id='io.github.aerocyber.sitemarker',
                         flags=Gio.ApplicationFlags.DEFAULT_FLAGS)

        self.settings = Gio.Settings(schema_id="io.github.aerocyber.sitemarker")

        self.create_action('quit', lambda *_: self.quit(), ['<primary>q'])
        self.create_action('about', self.on_about_action)
        self.create_action('import', self.on_import_action)
        self.set_accels_for_action("win.add", ['<ctrl>n'])
        self.set_accels_for_action("win.del", ['<ctrl>d'])
        self.set_accels_for_action("win.view", ['<ctrl>v'])
        self.set_accels_for_action("win.view-omio", ['<ctrl>o'])
        self.set_accels_for_action("win.import", ['<ctrl>i'])
        self.set_accels_for_action("win.export", ['<ctrl>e'])
        self.set_accels_for_action("win.docs", ['<ctrl>h'])

        # Dark mode
        dark_mode = self.settings.get_boolean("dark-mode")
        style_manager = Adw.StyleManager.get_default()
        if dark_mode:
            style_manager.set_color_scheme(Adw.ColorScheme.FORCE_DARK)
        else:
            style_manager.set_color_scheme(Adw.ColorScheme.DEFAULT)

        dark_mode_action = Gio.SimpleAction(name="dark-mode",
                                            state=GLib.Variant.new_boolean(dark_mode))
        dark_mode_action.connect("activate", self.toggle_dark_mode)
        dark_mode_action.connect("change-state", self.change_color_scheme)
        self.add_action(dark_mode_action)

    def do_activate(self):
        """Called when the application is activated.

        We raise the application's main window, creating it if
        necessary.
        """
        win = self.props.active_window
        if not win:
            win = SitemarkerWindow(application=self)
        win.present()

    def on_import_action():
        s = SiteMarkerWindow()
        s.on_import_action()

    def on_about_action(self, widget, _):
        """Callback for the app.about action."""
        about = Adw.AboutWindow(transient_for=self.props.active_window,
                                application_name='SiteMarker',
                                application_icon='io.github.aerocyber.sitemarker',
                                developer_name='Aero',
                                version='1.2.1',
                                developers=['Aero https://github.com/aerocyber'],
                                copyright='© 2023 Aero',
                                license_type=Gtk.License.MIT_X11,
                                comments="An open source bookmark manager.")
        about.set_website("https://github.com/aerocyber/sitemarker")
        about.add_link("Donate", "https://github.com/sponsors/aerocyber")

        # Contributors require credits, especially code contributors.
        contributors = self.get_contributors()
        about.add_credit_section("Contributors", contributors)

        # So does translators!
        translators = self.get_translators()
        about.add_credit_section("Translators", translators)

        about.set_application_icon("io.github.aerocyber.sitemarker")

        # Present it!
        about.present()


    def create_action(self, name, callback, shortcuts=None):
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
        if shortcuts:
            self.set_accels_for_action(f"app.{name}", shortcuts)

    def get_contributors(self):
        return [
        ]
        # Append your names here, contributors!
        # Format: "Name url""

    def get_translators(self):
        return [
        ]
        # Append your name here, translators!
        # Format: "Name url")

    def change_color_scheme(self, action, new_state):
        dark_mode = new_state.get_boolean()
        style_manager = Adw.StyleManager.get_default()
        if dark_mode:
            style_manager.set_color_scheme(Adw.ColorScheme.FORCE_DARK)
        else:
            style_manager.set_color_scheme(Adw.ColorScheme.DEFAULT)
        action.set_state(new_state)
        self.settings.set_boolean("dark-mode", dark_mode)

    def toggle_dark_mode(self, action, _):
        state = action.get_state()
        old_state = state.get_boolean()
        new_state = not old_state
        action.change_state(GLib.Variant.new_boolean(new_state))

def main(version):
    """The application's entry point."""
    app = SitemarkerApplication()
    return app.run(sys.argv)
