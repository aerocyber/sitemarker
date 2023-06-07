pkgdatadir = join_paths(get_option('prefix'), get_option('datadir'), meson.project_name())
moduledir = join_paths(pkgdatadir, 'sitemarker')

python = import('python')

conf = configuration_data()
conf.set('PYTHON', python.find_installation('python3').path())
conf.set('VERSION', meson.project_version())
conf.set('localedir', join_paths(get_option('prefix'), get_option('localedir')))
conf.set('pkgdatadir', pkgdatadir)

configure_file(
  input: 'sitemarker.in',
  output: 'sitemarker',
  configuration: conf,
  install: true,
  install_dir: get_option('bindir'),
  install_mode: 'r-xr--r--'
)

sitemarker_sources = [
  '__init__.py',
  'main.py',
  'window.py',
  'ospyata.py',
  'definitions.py',
  'add.py',
  'delete.py',
  'error_window.py',
  'notify_window.py',
  'data.py'
]

install_data(sitemarker_sources, install_dir: moduledir)
