Name:           sitemarker
Version:        3.1.0
Release:        1%{?dist}
Summary:        An open source bookmark manager.
License:        MIT
URL:            https://github.com/aerocyber/sitemarker
Source0:        %{name}-%{version}.tar.xz

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


%files
%license LICENSE
%{_bindir}/sitemarker
%{_datadir}/sitemarker/
%{_datadir}/applications/io.github.aerocyber.sitemarker.desktop
%{_datadir}/glib-2.0/schemas/io.github.aerocyber.sitemarker.gschema.xml
%{_datadir}/icons/hicolor/scalable/apps/io.github.aerocyber.sitemarker.svg
%{_datadir}/icons/hicolor/symbolic/apps/io.github.aerocyber.sitemarker-symbolic.svg
%{_datadir}/appdata/io.github.aerocyber.sitemarker.appdata.xml

%post
chmod +x %{_bindir}/sitemarker

%changelog
%autochangelog
