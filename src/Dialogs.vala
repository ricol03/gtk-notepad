/****
 * Dialogs.vala - contains the menu dialogs logic
 * ricol03, 2026
 ****/

public class Dialogs {
	public Dialogs() {}
	
	public void checkfile(Gtk.Window window, Gtk.TextView textview, File file) {
		if (file != null) {
			uint8[] array;
			file.load_contents (null, out array, null);
			var buffer = textview.get_buffer();
			buffer.set_text ((string)array);

			string path2 = file.get_path ();
			
			if (path2 != null) {
				string windowtitle2 = "%s - Notepad".printf (path2 ?? "(unknown)");
				window.title = windowtitle2;
			}
		}
    }
	
	public void openFileDialog(Gtk.ApplicationWindow main_window, Gtk.TextView textview) {
    	var dialog = new Gtk.FileDialog();
		dialog.title = "Save File";

		dialog.open(main_window, null, (obj, res) => {
			try {
				File file2 = dialog.open.end(res);

				if (file2 != null)
					checkfile(main_window, textview, file2);

			} catch (Error e) {
				warning("- %s".printf(e.message));
			}
		});
    }

	public void saveFileDialog(Gtk.ApplicationWindow main_window, Gtk.TextView textview) {
		var dialog = new Gtk.FileDialog();
		dialog.title = "Save File";

		dialog.save.begin(main_window, null, (obj, res) => {
			try {
				File file = dialog.save.end(res);
				FileOutputStream newfile = null;

				if (file.query_exists(null))
					newfile = file.replace(null, true, FileCreateFlags.PRIVATE, null);
				else
					newfile = file.create(FileCreateFlags.PRIVATE, null);

				Gtk.TextIter start, end;
				var buffer = textview.get_buffer();
				buffer.get_bounds (out start, out end);
				string text = buffer.get_text(start, end, false);

				newfile.write(text.data);
				newfile.close();

			} catch (Error e) {
				warning("- %s".printf(e.message));
			}
		});
    }
}