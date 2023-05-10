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

from gi.repository import Gtk, Gio, Adw
from .window import OsmataWindow


class OsmataApplication(Adw.Application):
    """The main application singleton class."""

    def __init__(self):
        super().__init__(application_id='com.github.aerocyber.osmata',
                         flags=Gio.ApplicationFlags.DEFAULT_FLAGS)

        self.create_action('quit', lambda *_: self.quit(), ['<primary>q'])
        self.create_action('about', self.on_about_action)
        self.create_action('preferences', self.on_preferences_action)
        self.set_accels_for_action("win.add", ['<ctrl>n'])
        self.set_accels_for_action("win.del", ['<ctrl>d'])
        self.set_accels_for_action("win.view", ['<ctrl>v'])
        self.set_accels_for_action("win.view-omio", ['<ctrl>o'])
        self.set_accels_for_action("win.import", ['<ctrl>i'])
        self.set_accels_for_action("win.export", ['<ctrl>e'])

    def do_activate(self):
        """Called when the application is activated.

        We raise the application's main window, creating it if
        necessary.
        """
        win = self.props.active_window
        if not win:
            win = OsmataWindow(application=self)
        win.present()

    def on_about_action(self, widget, _):
        """Callback for the app.about action."""
        about = Adw.AboutWindow(transient_for=self.props.active_window,
                                application_name='Osmata',
                                application_icon='com.github.aerocyber.osmata',
                                developer_name='Aero',
                                version='1.0.0',
                                developers=['Aero https://github.com/aerocyber'],
                                copyright='© 2023 Aero',
                                license_type=Gtk.License.MIT_X11,
                                comments="An open source bookmark manager.")
        about.set_website("https://github.com/aerocyber/osmata")

        # Contributors require credits, especially code contributors.
        contributors = self.get_contributors()
        about.add_credit_section("Contributors", contributors)

        # So does translators!
        translators = self.get_translators()
        about.add_credit_section("Translators", translators)

        about.set_application_icon("com.github.aerocyber.osmata")

        # Present it!
        about.present()

    def on_preferences_action(self, widget, _):
        """Callback for the app.preferences action."""
        # TODO: Update code to set preferences.
        print('app.preferences action activated')



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



def main(version):
    """The application's entry point."""
    app = OsmataApplication()
    return app.run(sys.argv)
