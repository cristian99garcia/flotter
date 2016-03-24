namespace Flotter {

    public class ListViewRow: Gtk.EventBox {

        public signal void color_changed(double[] color);
        public signal void remove_function();
        public signal void show_notable_points(bool show);
        public signal void selected();
        public signal void unselected();

        public Flotter.Function function;

        public Gtk.Box box;
        public Gtk.CheckButton check_button;
        public Gtk.ColorButton color_button;
        public Gtk.Label label;
        public Gtk.Button close_button;

        public Flotter.ListViewRowState state = Flotter.ListViewRowState.DISACTIVATED;

        public ListViewRow(Flotter.Function function) {
            Flotter.show_msg("NEW: src/list_view.vala Flotter.ListViewRow %s".printf(function.get_formula()));

            this.function = function;
            this.set_events(Gdk.EventMask.ALL_EVENTS_MASK);

            this.box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.box.set_margin_top(2);
            this.box.set_margin_bottom(2);
            this.box.set_margin_start(2);
            this.box.set_margin_end(2);
            this.box.set_size_request(1, 30);
            this.box.set_events(Gdk.EventMask.ALL_EVENTS_MASK);
            this.add(this.box);

            this.check_button = new Gtk.CheckButton();
            this.check_button.toggled.connect(this.show_points_changed);
            this.check_button.button_release_event.connect(this.ignore_check_button);
            this.box.pack_start(this.check_button, false, false, 0);

            Gdk.RGBA rgba = Gdk.RGBA();
            rgba.red = function.color[0];
            rgba.green = function.color[1];
            rgba.blue = function.color[2];
            rgba.alpha = 1;

            this.color_button = new Gtk.ColorButton.with_rgba(rgba);
            this.color_button.color_set.connect(this.color_selected_cb);
            this.color_button.button_release_event.connect(this.ignore_color_button);
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

            this.enter_notify_event.connect(this.mouse_enter_cb);
            this.leave_notify_event.connect(this.mouse_leave_cb);
            this.button_release_event.connect(this.button_release_cb);
            this.selected.connect(this._selected_cb);
            this.unselected.connect(this._unselected_cb);

            this.update_theme();
        }

        private bool ignore_check_button(Gtk.Widget button, Gdk.EventButton event) {
            this.check_button.set_active(!this.check_button.get_active());
            return true;
        }

        private bool ignore_color_button(Gtk.Widget button, Gdk.EventButton event) {
            this.color_button.clicked();
            return true;
        }

        private bool mouse_enter_cb(Gtk.Widget widget, Gdk.EventCrossing event) {
            if (this.state == Flotter.ListViewRowState.DISACTIVATED) {
                this.set_row_state(Flotter.ListViewRowState.MOUSE_OVER);
            }
            return false;
        }

        private bool mouse_leave_cb(Gtk.Widget widget, Gdk.EventCrossing event) {
            if (this.state == Flotter.ListViewRowState.MOUSE_OVER) {
                this.set_row_state(Flotter.ListViewRowState.DISACTIVATED);
            }
            return false;
        }

        private bool button_release_cb(Gtk.Widget self, Gdk.EventButton event) {
            if (event.button == 1 && this.state != Flotter.ListViewRowState.ACTIVATED) {
                this.state = Flotter.ListViewRowState.ACTIVATED;
                this.selected();
            } else if (event.button == 1 && this.state != Flotter.ListViewRowState.DISACTIVATED) {
                this.state = Flotter.ListViewRowState.DISACTIVATED;
                this.unselected();
            } else if (event.button == 2) {
                // show menu
            }

            return false;
        }

        private void _selected_cb() {
            this.state = Flotter.ListViewRowState.ACTIVATED;
            this.update_theme();
        }

        private void _unselected_cb() {
            this.state = Flotter.ListViewRowState.DISACTIVATED;
            this.update_theme();
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

        private void show_points_changed(Gtk.ToggleButton button) {
            this.show_notable_points(button.get_active());
        }

        public void update_theme() {
            string theme = "";

            if (this.state == Flotter.ListViewRowState.ACTIVATED) {
                theme = "GtkEventBox { background-color: rgb(88, 163, 234) }";
            } else if (this.state == Flotter.ListViewRowState.DISACTIVATED) {
                theme = "GtkEventBox { background-color: rgb(255, 255, 255) }";
            } else if (this.state == Flotter.ListViewRowState.MOUSE_OVER) {
                theme = "GtkEventBox { background-color: rgb(230, 230, 230) }";
            }

            Flotter.apply_theme(this, theme);
        }

        public void set_row_state(Flotter.ListViewRowState state, bool emit = false) {
            if (this.state != state) {
                this.state = state;

                if (emit) {
                    if (this.state == Flotter.ListViewRowState.ACTIVATED) {
                        this.selected();
                    } else if (this.state == Flotter.ListViewRowState.DISACTIVATED) {
                        this.unselected();
                    }
                }
            }

            this.update_theme();
        }

        public void set_selected(bool selected, bool emit = false) {
            Flotter.ListViewRowState state;
            if (selected) {
                state = Flotter.ListViewRowState.ACTIVATED;
            } else {
                state = Flotter.ListViewRowState.DISACTIVATED;
            }

            this.set_row_state(state, emit);
        }
    }

    public class ListView: Gtk.Box {

        public signal void selection_changed(Flotter.Function? function);
        public signal void function_removed(Flotter.Function function);
        public signal void color_changed(Flotter.Function function, double[] color);
        public signal void show_notable_points(Flotter.Function function, bool show);

        public Flotter.ListViewRow[] rows;
        public Gtk.Box list_view;

        public ListView() {
            Flotter.show_msg("STARTING: src/list_view.vala Flotter.ListView");

            this.rows = { };
            this.set_orientation(Gtk.Orientation.VERTICAL);

            string theme = "GtkBox { background-color: rgb(255, 255, 255) }";
            Flotter.apply_theme(this, theme);

            this.button_press_event.connect(this.button_press_cb);
        }

        private bool button_press_cb(Gtk.Widget widget, Gdk.EventButton event) {
            return false;
        }

        private void row_selected_cb(Flotter.ListViewRow? row) {
            Flotter.show_msg("src/list_view.vala Flotter.ListView.row_selected_cb");

            foreach (Flotter.ListViewRow _row in this.rows) {
                _row.set_selected(_row == row);
            }

            if (row == null) {
                this.selection_changed(null);
                return;
            }

            this.selection_changed(row.function);
        }

        private void color_changed_cb(Flotter.ListViewRow row, double[] color) {
            Flotter.show_msg("src/list_view.vala Flotter.ListView.color_changed_cb");
            this.color_changed(row.function, color);
        }

        private void function_removed_cb(Flotter.ListViewRow row) {
            Flotter.show_msg("src/list_view.vala Flotter.ListView.function_removed_cb");
            Flotter.ListViewRow[] rows = { };

            foreach (Flotter.ListViewRow _row in this.rows) {
                if (_row != row) {
                    rows += _row;
                }
            }

            this.rows = rows;

            this.remove(row);
            this.function_removed(row.function);
        }

        private void show_notable_points_cb(Flotter.ListViewRow row, bool show) {
            Flotter.show_msg("src/list_view.vala Flotter.ListView.show_notable_points_cb");
            this.show_notable_points(row.function, show);
        }

        public Flotter.ListViewRow? get_selected_row() {
            foreach (Flotter.ListViewRow row in this.rows) {
                if (row.state == Flotter.ListViewRowState.ACTIVATED) {
                    return row;
                }
            }

            return null;
        }

        public void add_function(Flotter.Function function) {
            Flotter.show_msg("src/list_view.vala Flotter.ListView.add_function %s".printf(function.get_formula()));

            Flotter.ListViewRow row = new Flotter.ListViewRow(function);
            row.color_changed.connect(this.color_changed_cb);
            row.remove_function.connect(this.function_removed_cb);
            row.show_notable_points.connect(this.show_notable_points_cb);
            row.selected.connect(this.row_selected_cb);
            row.unselected.connect(() => { this.row_selected_cb(null); });

            Flotter.ListViewRow[] rows = this.rows;
            rows += row;
            this.rows = rows;

            this.pack_start(row, false, false, 0);
            this.show_all();
        }
    }
}
