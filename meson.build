project('io.ricol03.gtk-notepad',
    'vala', 'c'
)

executable(
    meson.project_name(),
    'src' / 'Application.vala',
    'src' / 'Dialogs.vala',
    dependencies: [
        dependency('granite-7'),
        dependency('gtk4'),
        dependency('gio-2.0'),
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
    ],
    install: true
)

install_data(
    'data' / 'gtk-notepad.desktop',
    install_dir: get_option('datadir') / 'applications'
)
