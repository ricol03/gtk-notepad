/****
 * Application.vala - contains the main window logic
 * ricol03, 2026
 ****/

public class MyApp : Gtk.Application {
	private Dialogs dialog = new Dialogs();
	private Gtk.ApplicationWindow main_window;
	private Gtk.TextView text_view;
    private File? file;
	private string path;
	private string windowtitle = "Notepad";

    public MyApp() {
		Object (
			application_id: "io.ricol03.gtk-notepad",
			flags: ApplicationFlags.DEFAULT_FLAGS
		);
    }

    protected override void startup() {
		base.startup();

		var quit_action = new SimpleAction ("quit", null);

		add_action(quit_action);
		set_accels_for_action("app.quit", new string[] {"<Control>q", "<Control>w"});
		quit_action.activate.connect(quit);

		var save_action = new SimpleAction ("save", null);

		add_action(save_action);
		set_accels_for_action("app.save", new string[] {"<Control>s"});
		save_action.activate.connect(() => {
			dialog.saveFileDialog(main_window, text_view);
		});

		var open_action = new SimpleAction ("open", null);

		add_action(open_action);
		set_accels_for_action("app.open", new string[] {"<Control>o"});
		open_action.activate.connect(() => {
			dialog.openFileDialog (main_window, text_view);
		});
    }

    protected override void activate() {
		text_view = new Gtk.TextView() {
			margin_top = 2,
			margin_bottom = 2,
			margin_start = 6,
			margin_end = 2
		};

		var menubox = new Menu();

		menubox.append("Open File...", "app.open");
		menubox.append("Save File...", "app.save");
		menubox.append("Quit", "app.quit");

		var menubtn = new Gtk.MenuButton() {
			icon_name = "open-menu-symbolic",
			primary = true,
			tooltip_markup = Granite.markup_accel_tooltip({"F10"}, "Menu")
		};
		menubtn.set_menu_model(menubox);

		var headerbar = new Gtk.HeaderBar() {
			show_title_buttons = true
		};
		headerbar.pack_end(menubtn);

		var button = new Gtk.Button.with_label("File") {
			margin_top = 2,
			margin_bottom = 2,
			margin_start = 6,
			margin_end = 2
		};

		var scrolled = new Gtk.ScrolledWindow();
		scrolled.set_child(text_view);

		var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 1);

		box.append(text_view);

		main_window = new Gtk.ApplicationWindow(this) {
			child = scrolled,
			titlebar = headerbar,
			default_height = 500,
			default_width = 600,
			title = windowtitle
		};

		main_window.present();
    }

    public static int main(string[] args) {
		return new MyApp().run (args);
    }
}