namespace Flotter {

    public class Window: Gtk.ApplicationWindow {

        public Flotter.HeaderBar headerbar;
        public Flotter.ListView list_view;
        public Flotter.Area area;
        public Flotter.Entry entry;
        public Flotter.SaveDialog save_dialog;

        public Window() {
            this.set_default_size(640, 480);

            this.headerbar = new Flotter.HeaderBar();
            this.headerbar.save.connect(this.save_cb);
            this.set_titlebar(this.headerbar);

            Gtk.Box hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.add(hbox);

            this.list_view = new Flotter.ListView();
            this.list_view.selection_changed.connect(this.selection_changed_cb);
            this.list_view.function_removed.connect(this.function_removed_cb);
            this.list_view.color_changed.connect(this.color_changed_cb);
            this.list_view.show_notable_points.connect(this.show_notable_points_cb);
            hbox.pack_start(this.list_view, false, false, 0);

            Gtk.Box vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            hbox.pack_end(vbox, true, true, 0);

            this.area = new Flotter.Area();
            vbox.pack_start(this.area, true, true, 0);

            this.entry = new Flotter.Entry();
            this.entry.new_function.connect(this.add_function);
            vbox.pack_end(this.entry, false, false, 0);

            if (Flotter.DEBUG) {
                this.add_function(new Flotter.Function.from_values(Flotter.FunctionType.CUADRATIC, {4, 6, 1}));
                this.add_function(new Flotter.Function.from_values(Flotter.FunctionType.LINEAL, {4, 6}));
                this.add_function(new Flotter.Function.from_values(Flotter.FunctionType.LINEAL, {3, 1}));
            }

            this.save_dialog = new Flotter.SaveDialog(this.area);
            this.save_dialog.set_transient_for(this);
            this.save_dialog.hide();

            this.show_all();
        }

        private void selection_changed_cb(Flotter.Function? function) {
            this.area.select_function(function);
        }

        private void function_removed_cb(Flotter.Function function) {
            this.area.remove_function(function);
        }

        private void color_changed_cb(Flotter.Function function, double[] color) {
            function.color = color;
            this.area.update();
        }

        private void show_notable_points_cb(Flotter.Function function, bool show) {
            function.show_notable_points = show;
            this.area.update();
        }

        private void save_cb(Flotter.HeaderBar headerbar) {
            this.save_dialog.show_all();
        }

        public void add_function(Flotter.Function function) {
            this.area.add_function(function);
            this.list_view.add_function(function);
        }
    }
}
