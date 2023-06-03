pkgdatadir = join_paths(get_option('prefix'), get_option('datadir'), meson.project_name())
moduledir = join_paths(pkgdatadir, 'sitemarker')
gnome = import('gnome')

gnome.compile_resources('sitemarker',
  'sitemarker.gresource.xml',
  gresource_bundle: true,
  install: true,
  install_dir: pkgdatadir,
)