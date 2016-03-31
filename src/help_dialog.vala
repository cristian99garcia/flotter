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

                    break;

                case Flotter.FunctionType.CUBIC:
                    break;

                case Flotter.FunctionType.RACIONAL:
                    break;

                case Flotter.FunctionType.EXPONENTIAL:
                    break;
            }

            bool plural = (this.function.get_roots().length > 1);
            Gtk.Label tlabel = new Gtk.Label("¿Cómo calcular %s %s?".printf(plural? "las": "la", plural? "raices": "raíz"));
            tlabel.set_xalign(0);
            this.box.pack_start(tlabel, false, false, 0);

            foreach (string s in steps) {
                string step = Flotter.clean_double(s);

                Gtk.Label label = new Gtk.Label(step);
                label.set_xalign(0);
                this.box.pack_start(label, false, false, 0);
            }
        }
    }
}
