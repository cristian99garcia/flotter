namespace Flotter {

    public class Entry: Gtk.Entry {

        public signal void new_function(Flotter.Function function);

        public Entry() {
            Flotter.show_msg("START: src/entry.vala Flotter.Entry");

            this.set_placeholder_text("");
            this.activate.connect(this.activated);
        }

        private void activated() {
            Flotter.show_msg("src/entry.vala Flotter.Entry.activated");
            Flotter.Function? function = Flotter.get_function_from_string(this.get_text());

            this.set_text("");

            if (function != null) {
                this.new_function(function);
            }
        }
    }
}
