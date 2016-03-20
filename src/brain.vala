namespace Flotter {

    public class Function: GLib.Object {

        public Flotter.FunctionType type;
        public double[] values = {};  // For save data;
        public double[] color = Flotter.get_random_color();
        public string? name = null;
        public bool show_notable_points = false;

        public double a = 0;
        public double b = 0;
        public double c = 0;
        public double d = 0;
        public double e = 0;
        public double f = 0;
        public double g = 0;

        public Function() {
            Flotter.show_msg("START: src/brain.vala Flotter.Function");

            this.type = Flotter.FunctionType.NULL;
        }

        public Function.from_string(Flotter.FunctionType type, string data) {
            Flotter.show_msg("START: src/brain.vala Flotter.Function.from_string: Type: %s Data: %s".printf(type.to_string(), data));

            double[] values;
            string formula = data.replace(" ", "");
            this.type = type;

            if (formula.length > 5 && formula.slice(1, 5) == "(x)=") {
                formula = formula.slice(5, formula.length);
                Flotter.show_msg("src/brain.vala Flotter.Function.from_string: start with 'a(x)=', now: %s".printf(formula));
            }

            switch (this.type) {
                case Flotter.FunctionType.CONST:
                    values = Flotter.get_values_as_const(formula);
                    break;

                case Flotter.FunctionType.LINEAL:
                    values = Flotter.get_values_as_lineal(formula);
                    break;

                case Flotter.FunctionType.CUADRATIC:
                    values = Flotter.get_values_as_cuadratic(formula);
                    break;

                case Flotter.FunctionType.RACIONAL:
                    values = Flotter.get_values_as_racional(formula);
                    break;

                case Flotter.FunctionType.EXPONENTIAL:
                    values = Flotter.get_values_as_exponential(formula);
                    break;

                default:
                    return;
            }

            this.set_values(values);
        }

        public Function.from_values(Flotter.FunctionType type, double[] values) {
            this.type = type;
            this.set_values(values);
        }

        public void set_values(double[] values) {
            this.values = values;

            this.a = 0;
            this.b = 0;
            this.c = 0;
            this.d = 0;
            this.e = 0;
            this.f = 0;
            this.g = 0;

            switch (this.type) {
                case Flotter.FunctionType.CONST:
                    // A(x) = 3
                    this.a = values[Flotter.A];
                    break;

                case Flotter.FunctionType.LINEAL:
                    // B(x) = 2x + 1
                    this.a = values[Flotter.A];
                    this.b = values[Flotter.B];
                    break;

                case Flotter.FunctionType.CUADRATIC:
                    // C(x) = 4x^2 + 3x - 1
                    this.a = values[Flotter.A];
                    this.b = values[Flotter.B];
                    this.c = values[Flotter.C];
                    break;

                case Flotter.FunctionType.RACIONAL:
                    // D(x) = (3x - 4) / (2x + 2)
                    this.a = values[Flotter.A];
                    this.b = values[Flotter.B];
                    this.c = values[Flotter.C];
                    this.d = values[Flotter.D];
                    break;

                case Flotter.FunctionType.EXPONENTIAL:
                    // E(x) = 2^x + 1
                    this.a = values[Flotter.A];
                    this.b = values[Flotter.B];
                    break;
            }
        }

        public double? get_x(double y) {
            switch (this.type) {
                case Flotter.FunctionType.CONST:
                    return y;

                case Flotter.FunctionType.LINEAL:
                    return Flotter.get_x_as_lineal(this.values, y);

                case Flotter.FunctionType.CUADRATIC:
                    return Flotter.get_x_as_cuadratic(this.values, y, 0);

                case Flotter.FunctionType.RACIONAL:
                    return Flotter.get_x_as_racional(this.values, y);

                case Flotter.FunctionType.EXPONENTIAL:
                    return Flotter.get_x_as_exponential(this.values, y);
            }

            return 0;
        }

        public double get_y(double x) {
            switch (this.type) {
                case Flotter.FunctionType.CONST:
                    return this.a;

                case Flotter.FunctionType.LINEAL:
                    return Flotter.get_y_as_lineal(this.values, x);

                case Flotter.FunctionType.CUADRATIC:
                    return Flotter.get_y_as_cuadratic(this.values, x);

                case Flotter.FunctionType.RACIONAL:
                    return Flotter.get_y_as_racional(this.values, x);

                case Flotter.FunctionType.EXPONENTIAL:
                    return Flotter.get_y_as_exponential(this.values, x);
            }

            return 0;
        }

        public string get_formula() {
            Flotter.show_msg("src/brain.vala Flotter.Function.get_formula", this.type);

            string formula = "";

            switch (this.type) {
                case Flotter.FunctionType.CONST:
                    formula = Flotter.get_formula_as_const(this.values, this.name);
                    break;

                case Flotter.FunctionType.LINEAL:
                    formula = Flotter.get_formula_as_lineal(this.values, this.name);
                    break;

                case Flotter.FunctionType.CUADRATIC:
                    formula = Flotter.get_formula_as_cuadratic(this.values, this.name);
                    break;

                case Flotter.FunctionType.RACIONAL:
                    formula = Flotter.get_formula_as_racional(this.values, this.name);
                    break;

                case Flotter.FunctionType.EXPONENTIAL:
                    formula = Flotter.get_formula_as_exponential(this.values, this.name);
                    break;
            }

            return Flotter.clean_double(formula);
        }

        public double[] get_roots() {
            Flotter.show_msg("src/brain.vala Flotter.Function.get_notable_points", this.type);

            double[] solutions;
            double[] empty = {};
            double[] roots = {};

            switch (this.type) {
                case Flotter.FunctionType.CONST:
                    roots = { };
                    break;

                case Flotter.FunctionType.LINEAL:
                    roots = { Flotter.get_x_as_lineal(this.values, 0) };
                    break;

                case Flotter.FunctionType.CUADRATIC:
                    double? root1 = Flotter.get_x_as_cuadratic(this.values, 0, 0);
                    double? root2 = Flotter.get_x_as_cuadratic(this.values, 0, 1);
                    if (root1 == null && root2 == null) {
                        roots = { };
                    } else if (root1 != null && root2 == null) {
                        roots = { root1 };
                    } else {
                        roots = { root1, root2 };
                    }
                    break;

                case Flotter.FunctionType.RACIONAL:
                    solutions = Flotter.solve_as_racional(this.values);
                    if (solutions == empty) {
                        roots = { };
                    } else {
                        if (solutions.length == 1) {
                            roots = { solutions[0] };
                        } else if (solutions.length == 2) {
                            roots = { solutions[0], solutions[1] };
                        }
                    }
                    break;

                case Flotter.FunctionType.EXPONENTIAL:
                    solutions = Flotter.solve_as_exponential(this.values);
                    if (solutions == empty) {
                        roots = { };
                    } else {
                        roots = { solutions[0] };
                    }
                    break;
            }

            return roots;
        }

        public double[] get_intercepts() {
            // FIXME: translate name
            double[] intercepts = {};

            switch (this.type) {
                case Flotter.FunctionType.CONST:
                    intercepts = { this.a };
                    break;

                case Flotter.FunctionType.LINEAL:
                    intercepts = { Flotter.get_y_as_lineal(this.values, 0) };
                    break;

                case Flotter.FunctionType.CUADRATIC:
                    intercepts = { Flotter.get_y_as_cuadratic(this.values, 0) };
                    break;

                case Flotter.FunctionType.RACIONAL:
                    double? intercept = Flotter.get_y_as_racional(this.values, 0);

                    if (intercept == null) {
                        intercepts = { };
                    } else {
                        intercepts = { intercept };
                    }
                    break;

                case Flotter.FunctionType.EXPONENTIAL:
                    intercepts = { Flotter.get_y_as_exponential(this.values, 0) };
                    break;
            }

            return intercepts;
        }

        public double[] get_notable_points() {
            double[] points = {};

            foreach (double root in this.get_roots()) {
                points += root;  // X
                points += 0;     // Y
            }

            foreach (double intercept in this.get_intercepts()) {
                points += 0;          // X
                points += intercept;  // Y
            }

            if (this.type == Flotter.FunctionType.CUADRATIC) {
                // Add vertex
                double x = -(this.b / 2 * this.a);
                double y = this.get_y(x);

                points += x;
                points += y;
            }

            return points;
        }
    }
}
