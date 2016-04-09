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

        private void make_label(string text, bool bold = false, int size = 12, int space = 0) {
            Gtk.Label label = new Gtk.Label(null);
            label.set_markup(Flotter.clean_double(text));
            label.set_xalign(0);
            label.set_selectable(true);
            Flotter.apply_theme(label, "GtkLabel { font: Monospace %s %d; }".printf(bold? "bold": "", size));
            this.scrolled_box.pack_start(label, false, false, 0);

            if (space != 0) {
                Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
                box.set_size_request(1, space);
                this.scrolled_box.pack_start(box, false, false, 0);
            }
        }

        public void load_data() {
            string[] steps1 = { };
            string[] steps2 = { };
            string name = "";
            string reazon = "";

            switch (this.function.type) {
                case Flotter.FunctionType.CONST:
                    //steps = Flotter.solve_as_const_step_by_step(this.function);
                    name = "constante";
                    reazon = "Porque la x toma el mismo valor en todos los puntos";
                    break;

                case Flotter.FunctionType.LINEAL:
                    steps1 = Flotter.solve_as_lineal_step_by_step(this.function.values);
                    steps2 = Flotter.get_intercept_as_lineal_step_by_step(this.function.values, this.function.name);
                    if (function.b == 0) {
                        name = "lineal";
                        reazon = "Porque la gráfica de de la función es una recta que pasa por el <b>Origen de coordenadas</b>(0, 0)";
                    } else if (function.b != 0) {
                        name = "afin";
                        reazon = "Porque la gráfica de de la función es una recta que <b>no</b> pasa por el <b>Origen de coordenadas</b>(0, 0)";
                    }
                    break;

                case Flotter.FunctionType.CUADRATIC:
                    steps1 = Flotter.solve_as_cuadratic_step_by_step(this.function.values);
                    steps2 = Flotter.get_intercept_as_cuadratic_step_by_step(this.function.values, this.function.name);
                    name = "cuadrática";
                    reazon = "Porque la x está elevada al cuadrado (<b>x²</b>)";
                    break;

                case Flotter.FunctionType.CUBIC:
                    name = "cúbica";
                    reazon = "Porque la x está elevada al cubo (<b>x³</b>)";
                    break;

                case Flotter.FunctionType.RACIONAL:
                    steps1 = Flotter.solve_as_racional_step_by_step(this.function.values);
                    steps2 = Flotter.get_intercept_as_racional_step_by_step(this.function.values, this.function.name);
                    name = "racional";
                    reazon = "Porque es la razón (división) de los distintos valores que puede tomar x";
                    break;

                case Flotter.FunctionType.EXPONENTIAL:
                    name = "exponencial";
                    reazon = "Porque x es el exponente (<b>a<sup>x</sup></b>)";
                    break;
            }

            this.make_label("Función %s".printf(name), true, 16, 10);
            this.make_label("¿Por qué recibe este nombre?", true, 14, 2);
            this.make_label(reazon);
            this.make_label("");

            bool plural = (this.function.get_roots().length > 1);
            this.make_label("¿Cómo calcular %s?".printf(plural? "las raices": "la raíz"), true, 14, 2);

            string[] pre_words = { };
            pre_words += "Como queremos obtener la preimagen del 0, igualamos a 0 y luego resolvemos:";

            foreach (string frase in pre_words) {
                this.make_label(frase);
            }

            this.make_label("", false, 1, 10);

            foreach (string step in steps1) {
                this.make_label(step);
            }

            plural = (this.function.get_intercepts().length > 1);
            this.make_label("");
            this.make_label("¿Cómo calcular %s?".printf(plural? "las ordenadas en el origen": "la ordenada en el origen"), true, 14, 2);

            pre_words = { };
            pre_words += "Como queremos obtener la imagen del 0, reemplazamos las x por 0:";

            foreach (string frase in pre_words) {
                this.make_label(frase);
            }

            foreach (string step in steps2) {
                this.make_label(step);
            }
        }
    }
}
