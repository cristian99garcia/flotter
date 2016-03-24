namespace Flotter {

    public class HelpDialog: Gtk.Window {

        public Flotter.Function function;

        public HelpDialog(Flotter.Function function) {
            this.function = function;

            this.set_modal(true);
        }
    }
}
