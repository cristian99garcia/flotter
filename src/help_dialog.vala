namespace Flotter {

    public class HelpDialog: Gtk.Window {

        public Flotter.Function function;

        public Gtk.Box box;

        public HelpDialog(Flotter.Function function) {
            this.function = function;

            this.box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.add(this.box);

            this.set_modal(true);
            this.set_title("Ayuda");
            this.set_border_width(10);
            this.load_data();
        }

        public void load_data() {
            string[] steps1 = { };
            string[] steps2 = { };

            Gtk.Box box1 = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.box.pack_start(box1, false, false, 0);

            Gtk.Box box2 = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.box.pack_start(box2, false, false, 0);

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
            string[] pre_words = {};
            pre_words += "<b><big>¿Cómo calcular %s?</big></b>".printf(plural? "las raices": "la raíz");
            pre_words += "";
            pre_words += "Como queremos obtener la preimagen del 0, igualamos a 0 y luego resolvemos:";

            foreach (string frase in pre_words) {
                Gtk.Label label = new Gtk.Label(null);
                label.set_markup(frase);
                label.set_xalign(0);
                box1.pack_start(label, false, false, 0);
            }

            foreach (string step in steps1) {
                Gtk.Label label = new Gtk.Label(null);
                label.set_markup(Flotter.clean_double(step));
                label.set_xalign(0);
                box1.pack_start(label, false, false, 0);
            }

            plural = (this.function.get_intercepts().length > 1);
            pre_words = {};
            pre_words += "<b>¿Cómo calcular %s?</b>".printf(plural? "las ordenadas en el origen": "la ordenada en el origen");
            pre_words += "";
            pre_words += "Como queremos obtener la imagen del 0, reemplazamos las x por 0:";

            foreach (string frase in pre_words) {
                Gtk.Label label = new Gtk.Label(null);
                label.set_markup(frase);
                label.set_xalign(0);
                box2.pack_start(label, false, false, 0);
            }

            foreach (string step in steps2) {
                Gtk.Label label = new Gtk.Label(null);
                label.set_markup(Flotter.clean_double(step));
                label.set_xalign(0);
                box2.pack_start(label, false, false, 0);
            }
        }
    }
}
