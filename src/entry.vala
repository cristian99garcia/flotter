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
            Flotter.show_msg("Trying understand '%s'".printf(this.get_text()));

            string? name = null;
            Flotter.FunctionType? type = null;
            string text = this.get_text().replace(" ", "");
            this.set_text("");

            if (text.length > 5) {
                string n = text.slice(0, 5);
                if (n.has_suffix("(x)=")) {
                    name = n.slice(0, 1);
                    text = text.slice(5, text.length);
                }
            }

            string[] monomials = Flotter.split_in_monomials(text);

            if (text.has_prefix("(") && text.has_suffix(")") && ")/(" in text) {
                type = Flotter.FunctionType.RACIONAL;
            } else if ("^x" in text) {
                type = Flotter.FunctionType.EXPONENTIAL;
            } else {
                int max_degree = 0;

                foreach (string monomial in monomials) {
                    int degree;

                    if ("x" in monomial) {
                        degree = 1;
                        if ("^" in monomial) {
                            degree = int.parse(monomial.split("^")[1]);
                        }
                    } else {
                        degree = 0;
                    }

                    if (degree > max_degree) {
                        max_degree = degree;
                    }
                }

                if (max_degree < 3) {
                    switch (max_degree) {
                        case 0:
                            type = Flotter.FunctionType.CONST;
                            break;

                        case 1:
                            type = Flotter.FunctionType.LINEAL;
                            break;

                        case 2:
                            type = Flotter.FunctionType.CUADRATIC;
                            break;

                        default:
                            return;
                    }
                }
            }

            if (type == null) {
                return;
            }

            Flotter.Function function = new Flotter.Function.from_string(type, text);
            function.name = name;

            Flotter.show_msg("Resultant function: " + function.get_formula());

            this.new_function(function);
        }
    }
}
