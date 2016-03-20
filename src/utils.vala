namespace Flotter {

    public void show_msg(string msg, Flotter.FunctionType? type = null) {
        if (!Flotter.DEBUG) {
            return;
        }

        string message = msg;
        if (type != null) {
            message += " " + type.to_string();
        }

        print(msg + "\n");
    }

    public string clean_double(string n) {
        string number = n.replace(".000000", "");
        number = number.replace(".100000", ".1");
        number = number.replace(".200000", ".2");
        number = number.replace(".300000", ".3");
        number = number.replace(".400000", ".4");
        number = number.replace(".500000", ".5");
        number = number.replace(".600000", ".6");
        number = number.replace(".700000", ".7");
        number = number.replace(".800000", ".8");
        number = number.replace(".900000", ".9");

        number = number.replace(",000000", "");
        number = number.replace(",100000", ".1");
        number = number.replace(",200000", ".2");
        number = number.replace(",300000", ".3");
        number = number.replace(",400000", ".4");
        number = number.replace(",500000", ".5");
        number = number.replace(",600000", ".6");
        number = number.replace(",700000", ".7");
        number = number.replace(",800000", ".8");
        number = number.replace(",900000", ".9");

        return number;
    }

    public double parse_coefficient(string monomial) {
        double number;
        if (monomial.split("x")[0] != "") {
            number = double.parse(monomial.split("x")[0]);
        } else {
            number = 1;
        }

        return number;
    }

    public double? get_x_as_const(double[] values, double y) {
        return null;
    }

    public double? get_y_as_const(double[] values, double x) {
        return null;
    }

    public double get_x_as_lineal(double[] values, double y) {
        // ax + b = y
        // ax + b - y = 0
        double a = values[Flotter.A];
        double b = values[Flotter.B];
        return Flotter.solve_as_lineal({ a, b - y})[0];
    }

    public double get_y_as_lineal(double[] values, double x) {
        double a = values[Flotter.A];
        double b = values[Flotter.B];
        return (a * x) + b;
    }

    public double? get_x_as_cuadratic(double[] values, double y, int p) {
        // ax^2 + bx + c = y
        // ax^2 + bx + c - y = 0
        double a = values[Flotter.A];
        double b = values[Flotter.B];
        double c = values[Flotter.C];
        double[] solutions = Flotter.solve_as_cuadratic({ a, b, c - y });

        if (solutions.length == 1) {
            return solutions[0];
        } else if (solutions.length > 1 && p < solutions.length && p >= 0) {
            return solutions[p];
        } else {
            return null;
        }
    }

    public double get_y_as_cuadratic(double[] values, double x) {
        double a, b, c;
        a = values[Flotter.A];
        b = values[Flotter.B];
        c = values[Flotter.C];
        return (a * GLib.Math.pow(x, 2)) + (b * x) + c;
    }

    //public double get_x_as_cubic(double[] values, double y) {
    //    return 0;
    //}

    //public double get_y_as_cubic(double[] values, double x) {
    //    double a, b, c, d;
    //    a = values[Flotter.A];
    //    b = values[Flotter.B];
    //    c = values[Flotter.C];
    //    d = values[Flotter.D];
    //    return (a * GLib.Math.pow(x, 3)) + (b * GLib.Math.pow(x, 2)) + (c * x) + d;
    //}

    public double get_x_as_racional(double[] values, double y) {
        return 0;
    }

    public double? get_y_as_racional(double[] values, double x) {
        double a, b, c, d;
        a = values[Flotter.A];
        b = values[Flotter.B];
        c = values[Flotter.C];
        d = values[Flotter.D];

        if ((c * x) + d == 0) {
            return null;
        } else {
            return ((a * x) + b) / ((c * x) + d);
        }
    }

    public double get_x_as_exponential(double[] values, double y) {
        return 0;
    }

    public double get_y_as_exponential(double[] values, double x) {
        double a, b;
        a = values[Flotter.A];
        b = values[Flotter.B];
        return GLib.Math.pow(a, x) + b;
    }

    public double[] get_values_as_const(string data) {
        double a = double.parse(data);
        return { a };
    }

    public double[] get_values_as_lineal(string data) {
        Flotter.show_msg("src/utils.vala Flotter.get_values_as_lineal: %s".printf(data));
        string[] monomials = Flotter.split_in_monomials(data);

        string mons = "";

        foreach (string m in monomials) {
            mons += m + " ";
        }

        Flotter.show_msg("src/utils.vala Flotter.get_values_as_lineal (splited monomials) %s".printf(mons));

        double a = 0;
        double b = 0;

        foreach (string m in monomials) {
            if (m == "") {
                continue;
            }

            if ("x" in m) {
                a = Flotter.parse_coefficient(m);
            } else {
                b = double.parse(m);
            }
        }

        return { a, b };
    }

    public double[] get_values_as_cuadratic(string data) {
        string[] monomials = Flotter.split_in_monomials(data);

        double a = 0;
        double b = 0;
        double c = 0;

        foreach (string m in monomials) {
            if (m == "") {
                continue;
            }

            if ("x^" in m) {
                a = Flotter.parse_coefficient(m);
            } else if ("x" in m && !("x^" in m)) {
                b = Flotter.parse_coefficient(m);
            } else {
                c = double.parse(m);
            }
        }

        return { a, b, c };
    }

    public double[] get_values_as_racional(string data) {
        string term1 = data.split("/")[0];
        string term2 = data.split("/")[1];

        term1 = term1.slice(1, term1.length - 1);
        term2 = term2.slice(1, term2.length - 1);

        string[] mterm1 = Flotter.split_in_monomials(term1);
        string[] mterm2 = Flotter.split_in_monomials(term2);

        double a = 0;
        double b = 0;
        double c = 0;
        double d = 0;

        foreach (string m in mterm1) {
            if ("x" in m) {
                a = Flotter.parse_coefficient(m);
            } else {
                b = double.parse(m);
            }
        }

        foreach (string m in mterm2) {
            if ("x" in m) {
                c = Flotter.parse_coefficient(m);
            } else {
                d = double.parse(m);
            }
        }

        return { a, b, c, d };
    }

    public double[] get_values_as_exponential(string data) {
        string[] monomials = Flotter.split_in_monomials(data);

        double a = 0;
        double b = 0;

        foreach (string m in monomials) {
            if ("^x" in m) {
                a = Flotter.parse_coefficient(m);
            } else {
                b = double.parse(m);
            }
        }

        return { a, b };
    }

    public string get_formula_as_const(double[] values, string? name = null) {
        string formula;

        if (name != null) {
            formula = name + "(x) = ";
        } else {
            formula = "F(x) = ";
        }

        formula += values[Flotter.A].to_string();

        return formula;
    }

    public string get_formula_as_lineal(double[] values, string? name = null) {
        string formula;
        double a = values[Flotter.A];
        double b = values[Flotter.B];

        if (name != null) {
            formula = name + "(x) = ";
        } else {
            formula = "F(x) = ";
        }

        formula += "%fx".printf(a);

        if (b != 0) {
            if (b > 0) {
                formula += "+";
            }
            formula += b.to_string();
        }

        return formula;
    }

    public string get_formula_as_cuadratic(double[] values, string? name = null) {
        string formula;
        double a = values[Flotter.A];
        double b = values[Flotter.B];
        double c = values[Flotter.C];

        if (name != null) {
            formula = name + "(x) = ";
        } else {
            formula = "F(x) = ";
        }

        formula += "%fx^2".printf(a);

        if (b != 0) {
            if (b > 0) {
                formula += "+";
            }
            formula += "%fx".printf(b);
        }

        if (c != 0) {
            if (c > 0) {
                formula += "+";
            }
            formula += c.to_string();
        }

        return formula;
    }

    public string get_formula_as_racional(double[] values, string? name = null) {
        string formula;
        double a = values[Flotter.A];
        double b = values[Flotter.B];
        double c = values[Flotter.C];
        double d = values[Flotter.D];

        if (name != null) {
            formula = name + "(x) = ";
        } else {
            formula = "F(x) = ";
        }

        formula += "(%fx".printf(a);

        if (b != 0) {
            if (b > 0) {
                formula += "+";
            }
            formula += "%f)".printf(b);
        } else {
            formula += ")";
        }

        formula += " / (%fx".printf(c);

        if (d != 0) {
            if (d > 0) {
                formula += "+";
            }
            formula += "%f)".printf(d);
        } else {
            formula += ")";
        }

        return formula;
    }

    public string get_formula_as_exponential(double[] values, string? name = null) {
        string formula;
        double a = values[Flotter.A];
        double b = values[Flotter.B];

        if (name != null) {
            formula = name + "(x) = ";
        } else {
            formula = "F(x) = ";
        }

        formula += "%f^x".printf(a);

        if (b != 0) {
            if (b > 0) {
                formula += "+";
            }
            formula += b.to_string();
        }

        return formula;
    }

    public string[] split_in_monomials(string data) {
        Flotter.show_msg("src/utils.vala Flotter.split_in_monomials %s".printf(data));
        string text = data.replace("+", "SPLIT+");
        text = text.replace("-", "SPLIT-");
        text = text.replace("=", "SPLIT");
        text = text.replace("**", "^");
        text = text.replace(" ", "");

        string[] monomials;

        if ("SPLIT" in text) {
            monomials = text.split("SPLIT");
        } else {
            monomials = { text };
        }

        return monomials;
    }

    public double[] get_random_color() {
        double r = GLib.Random.double_range(0.0, 1.0);
        double g = GLib.Random.double_range(0.0, 1.0);
        double b = GLib.Random.double_range(0.0, 1.0);

        return { r, g, b };
    }

    public void apply_theme(Gtk.Widget widget, string theme) {
        Gtk.CssProvider style_provider = new Gtk.CssProvider();
        try {
            style_provider.load_from_data(theme, theme.length);
        } catch (GLib.Error error) {
            return;
        }

        Gtk.StyleContext context = widget.get_style_context();
        context.add_provider(style_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }

    public double[] solve_as_lineal(double[] values) {
        double[] solution = {};
        double a = values[Flotter.A];
        double b = values[Flotter.B];

        if (a == 0) {
            solution = { b };
        } else {
            solution = { b / (a * -1) };
        }

        return solution;
    }

    public double[] solve_as_cuadratic(double[] values) {
        double[] solutions = { };

        double a = values[Flotter.A];
        double b = values[Flotter.B];
        double c = values[Flotter.C];

        if (a != 0 && b != 0 && c != 0) {
            // Bhaskara:
            //  -b +- √(b^2 -4ac)
            //  ________________
            //        2a

            double z = (b * b) - (4 * (a * c));

            if (z < 0) {
                solutions = { };
            } else {
                double px = (-b + Math.sqrt(z)) / (2 * a);
                double nx = (-b - Math.sqrt(z)) / (2 * a);

                solutions = { px, nx };
            }
        } else if (a != 0 && b != 0 && c == 0) {
            // Example:
            //   8x^2 - 16x = 0
            //   8x * (x - 2) = 0
            //  By Hankel:
            //    Solution 1:
            //      x == 0
            //
            //    Solution 2:
            //      x - 2 == 0
            //      x = 2

            solutions = { a / b, 0 };
        } else if (a != 0 && b == 0 && c != 0) {
            if (c < 0) {
                // Example:
                //   2x^2 - 64 = 0
                //   2x^2 = 64
                //   Solution 1:
                //     2x = √64
                //     2x = 8
                //     x = 4
                //
                //   Solution 2:
                //     2x = √64
                //     2x = -8
                //     x = -4
                solutions = { GLib.Math.sqrt(c) / a, -(GLib.Math.sqrt(c) / a) };
            } else {
                solutions = { };
            }
        } else if (a != 0 && b == 0 && c == 0) {
            // Example:
            //   4x^2 = 0
            //   √4x^2 = √0
            //   4x = 0
            //   x = 0
            solutions = { 0, 0 };
        } else if (a == 0) {
            if (b == 0) {
                solutions = { c };
            } else {
                solutions = { (b - c) / a };
            }
        }

        return solutions;
    }

    public double[] solve_as_racional(double[] values) {
        double[] solutions = {};

        double a = values[Flotter.A];
        double b = values[Flotter.B];
        double c = values[Flotter.C];
        double d = values[Flotter.D];

        if (a != 0 && b != 0) {
            // Example:
            //  3x + 6
            //  ______ = 0
            //  x + 3
            //
            // 3x + 6 = 0
            // x = 6 / 2 = 3

            solutions = { a / b };
        } else if (a != 0 && b == 0 && d != 0) {
            // Example:
            //     2x
            //  _______ = 0
            //   x + 1
            //
            //     x
            //    ___ = 0
            //     1
            //
            //    x = 0

            solutions = { 0 };
        } else if (a != 0 && b != 0 && c != 0 && d == 0) {
            solutions =  { };
        } else if (c == 0) {
            solutions = { 0 };
        }

        return solutions;
    }

    public double[] solve_as_exponential(double[] values) {
        double[] solutions = {};

        double b = values[Flotter.B];

        if (b < 0) {
            solutions = { b + 1 };
        }

        return solutions;
    }

    /*
    public double[] solve_as_cubic(double[] values) {
        double x1 = 0;
        double x2 = 0;
        double x3 = 0;

        double a, b, c, d;
        a = values[Flotter.A];
        b = values[Flotter.B];
        c = values[Flotter.C];
        d = values[Flotter.D] - values[Flotter.E];

        if (d == 0) {
            // Example:
            // 4x^3 - 5x^2 - x = 0
            // x * (4x^2 - 5x - 1) = 0
            // Solution 1:
            //   x = 0
            //
            // Solution 2 n 3:
            //   Solve as cuadratic

            double[] other_solutions = Flotter.solve_as_cuadratic({ a, b, c });
            x1 = 0;
            x2 = other_solutions[1];
            x3 = other_solutions[3];
        } else if (d != 0) {
            double delta0 = (b * b) - (3 * a * c);
            double delta1 = (2 * GLib.Math.pow(b, 3)) - (9 * (a * b * c)) + (27 * GLib.Math.pow(a, 2) * d);
            //double delta = ((delta1 * delta1) - (4 * GLib.Math.pow(delta0, 3))) / -27 * GLib.Math.pow(a, 2);

            double C = (GLib.Math.pow(GLib.Math.sqrt((delta1 - (4 * (delta0 * delta0 * delta0))) + delta1), (1.0 / 3.0)) / 2.0);
            double u = (-1 + GLib.Math.sqrt(-3)) / 2.0;

            x1 = b + GLib.Math.pow(u, 1) * C + (delta0 / GLib.Math.pow(u, 1) * C) / (3 * a);
            x2 = b + GLib.Math.pow(u, 2) * C + (delta0 / GLib.Math.pow(u, 2) * C) / (3 * a);
            x3 = b + GLib.Math.pow(u, 3) * C + (delta0 / GLib.Math.pow(u, 3) * C) / (3 * a);
        }

        return { x1, x2, x3 };
    }*/
}
