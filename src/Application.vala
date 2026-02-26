/*
 *
 *
 */

using Gtk;

public class MyApp : Gtk.Application {
    private File? file;
	private string path;
	private string windowtitle = "Notepad";

    public MyApp () {
		Object (
			application_id: "io.ricol03.gtk-notepad",
			flags: ApplicationFlags.DEFAULT_FLAGS
		);
    }

    private void checkfile(Gtk.TextView textview) {
		if (file != null) {
			uint8[] array;
			file.load_contents (null, out array, null);
			var buffer = textview.get_buffer();
			buffer.set_text ((string)array);

			path = file.get_path ();

			if (path != null) {
				windowtitle = "$path - Notepad";
			}
		}
    }

    private void openFileDialog(Gtk.ApplicationWindow main_window, Gtk.TextView textview) {
		var filechooser = new Gtk.FileChooserDialog(
			"Select File",
			main_window,
			Gtk.FileChooserAction.OPEN,
			"Cancel",
			Gtk.ResponseType.CANCEL,
			"Open",
			Gtk.ResponseType.ACCEPT,
			null
		);

		filechooser.response.connect((id) => {
			if (id == Gtk.ResponseType.ACCEPT) {
			file = filechooser.get_file();

			if (file != null) {
				checkfile(textview);
			}
	    }
	    filechooser.destroy();
	});

	filechooser.present();
    }

    protected void createAction(Gtk.Button button, Gtk.ApplicationWindow window, Gtk.TextView textview) {
		var openaction = new SimpleAction("open", null);
		openaction.activate.connect(() => {
			openFileDialog(window, textview);
		});

		openaction.set_enabled(true);
		window.add_action(openaction);
    }

    protected override void startup () {
		base.startup ();

		var quit_action = new SimpleAction ("quit", null);

		add_action(quit_action);
		set_accels_for_action("app.quit", {"<Control>q", "<Control>w"});
		quit_action.activate.connect(quit);
    }

    protected override void activate () {
	//  var button_header = new Gtk.Button.from_icon_name ("process-stop") {
	//      action_name = "app.quit",
	//      tooltip_markup = Granite.markup_accel_tooltip(
	//          get_accels_for_action("app.quit"),
	//          "Quit"
	//      )
	//  };
	//  button_header.add_css_class (Granite.STYLE_CLASS_LARGE_ICONS);


		var otherwindow = new Gtk.ApplicationWindow (this);

		var text_view = new Gtk.TextView() {
			margin_top = 2,
			margin_bottom = 2,
			margin_start = 6,
			margin_end = 2
		};

		var openbtn = new Gtk.Button() {
			child = new Granite.AccelLabel.from_action_name("Open File...", "app.open")
		};
		openbtn.add_css_class(Granite.STYLE_CLASS_MENUITEM);

		createAction (openbtn, otherwindow, text_view);

		openbtn.clicked.connect(() => {
			openFileDialog(otherwindow, text_view);
		});

		var quitbtn = new Gtk.Button() {
			action_name = "app.quit",
			child = new Granite.AccelLabel.from_action_name("Quit", "app.quit")
		};
		quitbtn.add_css_class(Granite.STYLE_CLASS_MENUITEM);

		var menubox = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);

		menubox.append (openbtn);
		menubox.append (quitbtn);

		var popover = new Gtk.Popover() {
			child = menubox
		};
		popover.add_css_class(Granite.STYLE_CLASS_MENU);

		var menubtn = new Gtk.MenuButton() {
			icon_name = "open-menu",
			primary = true,
			popover = popover,
			tooltip_markup = Granite.markup_accel_tooltip({"F10"}, "Menu")
		};
		menubtn.add_css_class(Granite.STYLE_CLASS_LARGE_ICONS);

		var headerbar = new Gtk.HeaderBar () {
			show_title_buttons = true
		};
		headerbar.pack_end(menubtn);

		var button = new Gtk.Button.with_label ("File") {
			margin_top = 2,
			margin_bottom = 2,
			margin_start = 6,
			margin_end = 2
		};








		//  filechooserbtn.clicked.connect(() => {
		//      openFileDialog(otherwindow);
		//  });

		//var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);

		//box.append (text_view);
		//box.append (filechooserbtn);

		//string title = "Notepad";



		var main_window = new Gtk.ApplicationWindow (this) {
			child = text_view,
			titlebar = headerbar,
			default_height = 500,
			default_width = 600,
			title = windowtitle
		};

		main_window.present ();
    }

    public static int main (string[] args) {
		return new MyApp ().run (args);
    }
}