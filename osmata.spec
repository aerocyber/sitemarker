Name:           osmata
Version:        1.0.0
Release:        %autorelease
Summary:        An open source bookmark manager.
License:        MIT
URL:            https://github.com/aerocyber/osmata
Source:         https://github.com/aerocyber/osmaata/releases/latest/download/osmata-source.tar.gz

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
%{_bindir}/osmata
%{_datadir}/osmata/
%{_datadir}/applications/com.github.aerocyber.osmata.desktop
%{_datadir}/glib-2.0/schemas/com.github.aerocyber.osmata.gschema.xml
%{_datadir}/icons/hicolor/scalable/apps/com.github.aerocyber.osmata.svg
%{_datadir}/icons/hicolor/symbolic/apps/com.github.aerocyber.osmata-symbolic.svg
%{_datadir}/metainfo/com.github.aerocyber.osmata.metainfo.xml

%changelog
%autochangelog
