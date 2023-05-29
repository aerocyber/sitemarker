Name:           sitemarker
Version:        1.0.0
Release:        %autorelease
Summary:        An open source bookmark manager.
License:        MIT
URL:            https://github.com/aerocyber/sitemarker
Source:         https://github.com/aerocyber/sitemarker/releases/latest/download/sitemarker-source.tar.gz

Requires:       glib2
Requires:       gtk4
Requires:       libhandy1
Requires:       libadwaita
Requires:       libappstream-glib
Requires:       python3-gobject
BuildRequires:  meson
BuildRequires:  ninja-build
BuildRequires:  glib2-devel
BuildRequires:  libhandy1-devel
BuildRequires:  gtk4-devel
BuildRequires:  python3-gstreamer1
BuildRequires:  libadwaita-devel
BuildRequires:  python3-devel

BuildArch:      noarch

%description
A bookmark manager that helps sharing bookmarks easier.

%prep
%autosetup -p1


%build
%meson
%meson_build



%install
%meson_install

%find_lang %{name}


%files -f %{name}.lang
%license COPYING
%{_bindir}/sitemarker
%{_datadir}/sitemarker/
%{_datadir}/applications/io.github.aerocyber.sitemarker.desktop
%{_datadir}/glib-2.0/schemas/io.github.aerocyber.sitemarker.gschema.xml
%{_datadir}/icons/hicolor/scalable/apps/io.github.aerocyber.sitemarker.svg
%{_datadir}/icons/hicolor/symbolic/apps/io.github.aerocyber.sitemarker-symbolic.svg
%{_datadir}/metainfo/io.github.aerocyber.sitemarker.metainfo.xml

%changelog
%autochangelog
