namespace Flotter {

    public class Area: Gtk.DrawingArea {

        public GLib.List<Flotter.Function> functions;

        public double x = 0;
        public double y = 0;
        public double zoom = 1.0;

        public double? x_clicked = null;
        public double? y_clicked = null;

        private double width = 0;
        private double height = 0;

        public Flotter.Function? selected_function = null;

        public Area() {
            Flotter.show_msg("STARTING: src/area.vala Flotter.Area");

            this.set_size_request(1, 1);
            this.add_events(Gdk.EventMask.BUTTON_PRESS_MASK |
                            Gdk.EventMask.BUTTON_RELEASE_MASK |
                            Gdk.EventMask.BUTTON_MOTION_MASK);

            this.functions = new GLib.List<Flotter.Function>();

            this.draw.connect(this.draw_cb);
            this.realize.connect(this.realize_cb);
            this.button_press_event.connect(this.button_press_cb);
            this.button_release_event.connect(this.button_release_cb);
            this.motion_notify_event.connect(this.button_motion_cb);
        }

        private bool draw_cb(Gtk.Widget widget, Cairo.Context context) {
            Flotter.show_msg("src/area.vala Flotter.Area.draw_cb");

            this.draw_background(context);
            this.draw_axes(context);
            this.draw_grid(context);
            this.draw_functions(context);

            return false;
        }

        private void realize_cb(Gtk.Widget widget) {
            Flotter.show_msg("src/area.vala Flotter.Area.realize_cb");

            double[] size = this.get_size(true);
            this.width = size[Flotter.WIDTH];
            this.height = size[Flotter.HEIGHT];
        }

        private bool button_press_cb(Gtk.Widget widget, Gdk.EventButton event) {
            Flotter.show_msg("src/area.vala Flotter.Area.button_press_cb");

            this.x_clicked = event.x;
            this.y_clicked = event.y;
            this.set_cursor(Gdk.CursorType.FLEUR);

            return true;
        }

        private bool button_release_cb(Gtk.Widget widget, Gdk.EventButton event) {
            Flotter.show_msg("src/area.vala Flotter.Area.button_release_cb");

            this.set_cursor(Gdk.CursorType.ARROW);
            this.x_clicked = null;
            this.y_clicked = null;

            return true;
        }

        private bool button_motion_cb(Gtk.Widget widget, Gdk.EventMotion event) {
            Flotter.show_msg("src/area.vala Flotter.Area.button_motion_cb");

            this.set_cursor(Gdk.CursorType.FLEUR);

            this.x += (event.x - this.x_clicked) * this.zoom;
            this.y += (event.y - this.y_clicked) * this.zoom;

            this.x_clicked = event.x;
            this.y_clicked = event.y;

            this.update();

            return true;
        }

        private void draw_background(Cairo.Context context) {
            Flotter.show_msg("src/area.vala Flotter.Area.draw_background");

            double[] size = this.get_size(true);
            context.set_source_rgb(Flotter.BG_COLOR[0], Flotter.BG_COLOR[1], Flotter.BG_COLOR[2]);
            context.rectangle(0, 0, size[Flotter.WIDTH], size[Flotter.HEIGHT]);
            context.fill();
        }

        private void draw_grid(Cairo.Context context) {
            Flotter.show_msg("src/area.vala Flotter.Area.draw_grid");

            double[] size = this.get_size(true);

            double max_width = size[Flotter.WIDTH] - 20;
            double max_height = size[Flotter.HEIGHT] - 20;

            context.set_line_width(Flotter.GRID_LINE_WIDTH);
            context.set_source_rgb(Flotter.GRID_COLOR[0], Flotter.GRID_COLOR[1], Flotter.GRID_COLOR[2]);
            context.set_font_size(Flotter.GRID_FONT_SIZE);

            // Vertical lines
            for (int i=this.get_first_x(); i <= this.get_last_x(); i++) {
                if (i == 0) {
                    continue;
                }

                double x, y;
                this.get_coordinates(i, 0, out x, out y);
                context.move_to(x, 0);
                context.line_to(x, size[Flotter.HEIGHT]);
                context.stroke();
            }

            // Horizontal lines
            for (int i=this.get_first_y(); i <= this.get_last_y(); i++) {
                if (i == 0) {
                    continue;
                }

                double x, y;
                this.get_coordinates(0, i, out x, out y);
                context.move_to(0, y);
                context.line_to(size[Flotter.WIDTH], y);
                context.stroke();
            }

            // Horizontal numbers
            for (int i=this.get_first_x(); i <= this.get_last_x(); i++) {
                if (i == 0) {
                    continue;
                }
                double _x, _y;
                Cairo.TextExtents extents;

                this.get_coordinates(i, 0, out _x, out _y);
                context.text_extents(i.to_string(), out extents);

                _x -= (extents.width / 2.0);
                _y += Flotter.AXES_LINE_WIDTH;

                if (_y > max_height) {
                    _y = max_height;
                } else if (_y < 5) {
                    _y = 5;
                }

                context.set_source_rgb(Flotter.BG_COLOR[0], Flotter.BG_COLOR[1], Flotter.BG_COLOR[2]);
                context.rectangle(_x - 5, _y, extents.width + 10, extents.height + 8);
                context.fill();

                context.set_source_rgb(0, 0, 0);
                context.move_to(_x, _y + extents.height + 2);
                context.show_text(i.to_string());
            }

            // Vertical numbers
            for (int i=this.get_first_y(); i <= this.get_last_y(); i++) {
                if (i == 0) {
                    continue;
                }

                double _x, _y;
                Cairo.TextExtents extents;

                this.get_coordinates(0, i, out _x, out _y);
                context.text_extents(i.to_string(), out extents);

                _x += Flotter.AXES_LINE_WIDTH;
                // _y += (extents.height / 2.0);

                if (_x > max_width - extents.width - 5) {
                    _x = max_width - extents.width - 5;
                } else if (_x < 5) {
                    _x = 5;
                }

                context.set_source_rgb(Flotter.BG_COLOR[0], Flotter.BG_COLOR[1], Flotter.BG_COLOR[2]);
                context.rectangle(_x, _y - extents.height / 2.0 - 5, extents.width + 8, extents.height + 10);
                context.fill();

                context.set_source_rgb(0, 0, 0);
                context.move_to(_x + 2, _y + (extents.height / 2.0));
                context.show_text(i.to_string());
            }
        }

        private void draw_axes(Cairo.Context context) {
            Flotter.show_msg("src/area.vala Flotter.Area.draw_axes");

            double[] size = this.get_size(true);

            double _x, _y;
            this.get_coordinates(0, 0, out _x, out _y);

            context.set_line_width(Flotter.AXES_LINE_WIDTH);
            context.set_source_rgb(Flotter.AXES_COLOR[0], Flotter.AXES_COLOR[1], Flotter.AXES_COLOR[2]);

            // X axe
            context.move_to(0, _y);
            context.line_to(size[Flotter.WIDTH], _y);
            context.stroke();

            // Y axe
            context.move_to(_x, 0);
            context.line_to(_x, size[Flotter.HEIGHT]);
            context.stroke();
        }

        private void draw_functions(Cairo.Context context) {
            Flotter.show_msg("src/area.vala Flotter.Area.draw_functions");

            foreach (Flotter.Function function in this.functions) {
                Flotter.show_msg("src/area.vala Flotter.Area.draw_functions: Type: %s Formula: %s".printf(function.type.to_string(), function.get_formula()), function.type);

                if (function == this.selected_function) {
                    context.set_line_width(Flotter.PLOT_SELECTED_LINE_WIDTH);
                } else {
                    context.set_line_width(Flotter.PLOT_LINE_WIDTH);
                }

                double x, y;
                this.get_coordinates(this.get_first_x(), function.get_y(this.get_first_x()), out x, out y);

                context.move_to(x, y);
                context.set_source_rgb(function.color[0], function.color[1], function.color[2]);

                for (int i=this.get_first_x(); i <= this.get_last_x(); i++) {
                    for (double _i=0.05; _i <= 1.0; _i += 0.05) {
                        this.get_coordinates(i + _i, function.get_y(i + _i), out x, out y);
                        context.line_to(x, y);
                        context.stroke();

                        context.move_to(x, y);
                    }
                }
            }
        }

        public double[] get_size(bool actual = false) {
            if (!actual) {
                return { this.width, this.height };
            } else {
                Gtk.Allocation alloc;
                this.get_allocation(out alloc);

                return { alloc.width, alloc.height };
            }
        }

        public void get_coordinates(double _x, double _y, out double x, out double y) {
            double[] size = this.get_size();
            x = this.x + (size[Flotter.WIDTH] / 2.0) + (_x * Flotter.STEP);
            y = this.y + (size[Flotter.HEIGHT] / 2.0) - (_y * Flotter.STEP);
        }

        public int get_first_x() {
            double[] size = this.get_size();
            return -(int)(size[Flotter.WIDTH] / 2.0 / Flotter.STEP) - (int)(this.x / Flotter.STEP) - 2;
        }

        public int get_last_x() {
            int _x = (int)(this.x / Flotter.STEP);
            if (_x < 0) {
                _x *= -1;
            }

            double[] size = this.get_size(true);
            return (int)(size[Flotter.WIDTH] / Flotter.STEP) + _x + 2;
        }

        public int get_first_y() {
            double[] size = this.get_size(true);
            double y = (this.y / Flotter.STEP) - (size[Flotter.HEIGHT] / Flotter.STEP) - 2;
            return (int)y;
        }

        public int get_last_y() {
            double[] size = this.get_size(true);
            double y = (this.y / Flotter.STEP) + (size[Flotter.HEIGHT] / Flotter.STEP) + 2;

            return (int)y;
        }

        public void add_function(Flotter.Function function) {
            this.functions.append(function);
            this.update();
        }

        public void remove_function(Flotter.Function function) {
            this.functions.remove(function);
            this.update();
        }

        public void update() {
            Flotter.show_msg("src/area.vala Flotter.Area.update");

            GLib.Idle.add(() => {
                this.queue_draw();
                return false;
            });
        }

        public void set_cursor(Gdk.CursorType cursor) {
            Flotter.show_msg("src/area.vala Flotter.Area.set_cursor: %s".printf(cursor.to_string()));

            Gdk.Window? win = this.get_window();

            if (win == null) {
                return;
            }

            win.set_cursor(new Gdk.Cursor.for_display(this.get_display(), cursor));
        }

        public void select_function(Flotter.Function? function) {
            this.selected_function = function;
            this.update();
        }
    }
}
