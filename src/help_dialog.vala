namespace Flotter {

    public class HelpDialog: Gtk.Window {

        public Flotter.Function function;

        public Gtk.Box box;

        public HelpDialog(Flotter.Function function) {
            this.function = function;

            this.box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.add(this.box);

            this.set_modal(true);
            this.set_title("Ayuda");
            this.load_data();
        }

        public void load_data() {
            string[] steps = {  };

            switch (this.function.type) {
                case Flotter.FunctionType.CONST:
                    //steps = Flotter.solve_as_const_step_by_step(this.function);
                    break;

                case Flotter.FunctionType.LINEAL:
                    steps = Flotter.solve_as_lineal_step_by_step(this.function.values);
                    break;

                case Flotter.FunctionType.CUADRATIC:
                    steps = Flotter.solve_as_cuadratic_step_by_step(this.function.values);
                    break;

                case Flotter.FunctionType.CUBIC:
                    break;

                case Flotter.FunctionType.RACIONAL:
                    break;

                case Flotter.FunctionType.EXPONENTIAL:
                    break;
            }

            bool plural = (this.function.get_roots().length > 1);
            string[] pre_words = {};
            pre_words += "<b><big>¿Cómo calcular %s %s?</big></b>".printf(plural? "las": "la", plural? "raices": "raíz");
            pre_words += "";
            pre_words += "Como queremos obtener el punto de la función que tiene como ordenada 0, igualamos a 0 y luego resolvemos:";

            foreach (string frase in pre_words) {
                Gtk.Label label = new Gtk.Label(null);
                label.set_markup(frase);
                label.set_xalign(0);
                this.box.pack_start(label, false, false, 0);
            }

            foreach (string step in steps) {
                Gtk.Label label = new Gtk.Label(null);
                label.set_markup(Flotter.clean_double(step));
                label.set_xalign(0);
                this.box.pack_start(label, false, false, 0);
            }
        }
    }
}
