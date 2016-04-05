namespace Flotter {

    public class HelpDialog: Gtk.Window {

        public Flotter.Function function;

        public Gtk.Box box;
        public Gtk.ScrolledWindow scroll;
        public Gtk.Box scrolled_box;

        public HelpDialog(Flotter.Function function) {
            this.function = function;

            this.set_modal(true);
            this.set_title("Ayuda");
            this.set_border_width(10);
            this.set_default_size(450, 300);

            this.box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.add(this.box);

            this.scroll = new Gtk.ScrolledWindow(null, null);
            this.box.pack_start(this.scroll, true, true, 0);

            this.scrolled_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.scroll.add(this.scrolled_box);

            this.load_data();
        }

        private void make_label(string text, Gtk.Box box, bool bold = false, int size = 12) {
            Gtk.Label label = new Gtk.Label(null);
            label.set_markup(Flotter.clean_double(text));
            label.set_xalign(0);
            label.set_selectable(true);
            Flotter.apply_theme(label, "GtkLabel { font: Monospace %s %d; }".printf(bold? "bold": "", size));
            box.pack_start(label, false, false, 0);
        }

        public void load_data() {
            string[] steps1 = { };
            string[] steps2 = { };

            Gtk.Box box1 = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.scrolled_box.pack_start(box1, false, false, 0);

            Gtk.Box box2 = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.scrolled_box.pack_start(box2, false, false, 0);

            switch (this.function.type) {
                case Flotter.FunctionType.CONST:
                    //steps = Flotter.solve_as_const_step_by_step(this.function);
                    break;

                case Flotter.FunctionType.LINEAL:
                    steps1 = Flotter.solve_as_lineal_step_by_step(this.function.values);
                    steps2 = Flotter.get_intercept_as_lineal_step_by_step(this.function.values, this.function.name);
                    break;

                case Flotter.FunctionType.CUADRATIC:
                    steps1 = Flotter.solve_as_cuadratic_step_by_step(this.function.values);
                    steps2 = Flotter.get_intercept_as_cuadratic_step_by_step(this.function.values, this.function.name);
                    break;

                case Flotter.FunctionType.CUBIC:
                    break;

                case Flotter.FunctionType.RACIONAL:
                    steps1 = Flotter.solve_as_racional_step_by_step(this.function.values);
                    steps2 = Flotter.get_intercept_as_racional_step_by_step(this.function.values, this.function.name);
                    break;

                case Flotter.FunctionType.EXPONENTIAL:
                    break;
            }

            bool plural = (this.function.get_roots().length > 1);
            this.make_label("¿Cómo calcular %s?".printf(plural? "las raices": "la raíz"), box1, true, 14);

            string[] pre_words = { "" };
            pre_words += "Como queremos obtener la preimagen del 0, igualamos a 0 y luego resolvemos:";

            foreach (string frase in pre_words) {
                this.make_label(frase, box1);
            }

            foreach (string step in steps1) {
                this.make_label(step, box1);
            }

            plural = (this.function.get_intercepts().length > 1);
            this.make_label("", box2);
            this.make_label("¿Cómo calcular %s?".printf(plural? "las ordenadas en el origen": "la ordenada en el origen"), box2, true, 14);

            pre_words = { "" };
            pre_words += "Como queremos obtener la imagen del 0, reemplazamos las x por 0:";

            foreach (string frase in pre_words) {
                this.make_label(frase, box2);
            }

            foreach (string step in steps2) {
                this.make_label(step, box2);
            }
        }
    }
}
