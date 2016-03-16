namespace Flotter {

    public class ListViewRow: Gtk.ListBoxRow {

        public signal void color_changed(double[] color);
        public signal void remove_function();

        public Flotter.Function function;

        public Gtk.Box box;
        public Gtk.ColorButton color_button;
        public Gtk.Label label;
        public Gtk.Button close_button;

        public ListViewRow(Flotter.Function function) {
            Flotter.show_msg("NEW: src/list_view.vala Flotter.ListViewRow %s".printf(function.get_formula()));

            this.function = function;

            this.box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.box.set_margin_top(2);
            this.box.set_margin_bottom(2);
            this.box.set_margin_start(2);
            this.box.set_margin_end(2);
            this.add(this.box);

            Gdk.RGBA rgba = Gdk.RGBA();
            rgba.red = function.color[0];
            rgba.green = function.color[1];
            rgba.blue = function.color[2];
            rgba.alpha = 1;

            this.color_button = new Gtk.ColorButton.with_rgba(rgba);
            this.color_button.color_set.connect(this.color_selected_cb);
            this.box.pack_start(this.color_button, false, false, 0);

            this.label = new Gtk.Label(this.function.get_formula());
            this.label.set_xalign(0);
            this.box.pack_start(this.label, false, false, 5);

            this.close_button = new Gtk.Button();
            this.close_button.set_image(new Gtk.Image.from_icon_name("window-close-symbolic", Gtk.IconSize.MENU));
            this.close_button.set_border_width(0);

            string theme = "GtkButton { border-width: 0px; border-radius: 50px; }";
            Flotter.apply_theme(this.close_button, theme);

            this.close_button.clicked.connect(this.clicked_cb);
            this.box.pack_end(this.close_button, false, false, 0);
        }

        private void color_selected_cb(Gtk.ColorButton button) {
            Flotter.show_msg("src/list_view.vala Flotter.ListViewRow.color_selected_cb");

            Gdk.RGBA rgba = this.color_button.get_rgba();
            this.color_changed({ rgba.red, rgba.green, rgba.blue });
        }

        private void clicked_cb(Gtk.Button button) {
            Flotter.show_msg("src/list_view.vala Flotter.ListViewRow.clicked_cb %s".printf(function.get_formula()));
            this.remove_function();
        }
    }

    public class ListView: Gtk.ScrolledWindow {

        public signal void selection_changed(Flotter.Function? function);
        public signal void function_removed(Flotter.Function function);
        public signal void color_changed(Flotter.Function function, double[] color);

        public Gtk.ListBox list_view;

        public ListView() {
            Flotter.show_msg("STARTING: src/list_view.vala Flotter.ListView");

            this.set_size_request(200, 1);

            this.list_view = new Gtk.ListBox();
            this.list_view.row_selected.connect(this.row_selected_cb);
            this.add(this.list_view);
        }

        private void row_selected_cb() {
            Flotter.show_msg("src/list_view.vala Flotter.ListView.row_selected_cb");
            Gtk.ListBoxRow? row = this.list_view.get_selected_row();

            if (row == null) {
                this.selection_changed(null);
                return;
            }

            Flotter.ListViewRow lv_row = (row as Flotter.ListViewRow);
            this.selection_changed(lv_row.function);
        }

        private void color_changed_cb(Flotter.ListViewRow row, double[] color) {
            Flotter.show_msg("src/list_view.vala Flotter.ListView.color_changed_cb");
            this.color_changed(row.function, color);
        }

        private void function_removed_cb(Flotter.ListViewRow row) {
            Flotter.show_msg("src/list_view.vala Flotter.ListView.function_removed_cb");
            this.list_view.remove(row);
            this.function_removed(row.function);
        }

        public void add_function(Flotter.Function function) {
            Flotter.show_msg("src/list_view.vala Flotter.ListView.add_function %s".printf(function.get_formula()));

            Flotter.ListViewRow row = new Flotter.ListViewRow(function);
            row.color_changed.connect(this.color_changed_cb);
            row.remove_function.connect(this.function_removed_cb);
            this.list_view.add(row);
            this.show_all();
        }
    }
}
