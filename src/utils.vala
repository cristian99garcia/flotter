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

    public double? get_x_as_cuadratic(double[] values, double y, int p=0) {
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

    public double? get_x_as_cubic(double[] values, double y, int p=0) {
        // ax^3 + bx^2 + cx + d = y
        // ax^3 + bx^2 + cx + d - y = 0

        double a = values[Flotter.A];
        double b = values[Flotter.B];
        double c = values[Flotter.C];
        double d = values[Flotter.D];
        double[] solutions = Flotter.solve_as_cubic({ a, b, c, d - y });

        if (solutions.length == 1) {
            return solutions[0];
        } else if (solutions.length > 1 && p < solutions.length && p >= 0) {
            return solutions[p];
        } else {
            return null;
        }
    }

    public double get_y_as_cubic(double[] values, double x) {
        double a, b, c, d;
        a = values[Flotter.A];
        b = values[Flotter.B];
        c = values[Flotter.C];
        d = values[Flotter.D];
        return (a * GLib.Math.pow(x, 3)) + (b * GLib.Math.pow(x, 2)) + (c * x) + d;
    }

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
        // a^x + b = y
        // a^x + b - y = 0
        double a, b;
        a = values[Flotter.A];
        b = values[Flotter.B];
        return Flotter.solve_as_exponential({a, b - y})[0];
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

    public double[] get_values_as_cubic(string data) {
        string[] monomials = Flotter.split_in_monomials(data);

        double a = 0;
        double b = 0;
        double c = 0;
        double d = 0;

        foreach (string m in monomials) {
            if (m == "") {
                continue;
            }

            if ("x^" in m) {
                int degree = int.parse(m.split("x^")[1]);
                if (degree == 3) {
                    a = Flotter.parse_coefficient(m);
                } else if (degree == 2) {
                    b = Flotter.parse_coefficient(m);
                }
            } else if ("x" in m && !("x^" in m)) {
                c = Flotter.parse_coefficient(m);
            } else {
                d = double.parse(m);
            }
        }

        return { a, b, c, d };
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

    public string get_formula_as_cubic(double[] values, string? name = null) {
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

        formula += "%fx^3".printf(a);

        if (b != 0) {
            if (b > 0) {
                formula += "+";
            }
            formula += "%fx^2".printf(b);
        }

        if (c != 0) {
            if (c > 0) {
                formula += "+";
            }
            formula += "%fx".printf(c);
        }

        if (d != 0) {
            if (d > 0) {
                formula += "+";
            }
            formula += d.to_string();
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

    public string[] solve_as_lineal_step_by_step(double[] values) {
        // 3x + 1 = 0
        // 3x = -1
        // x = -1 / 3

        string[] steps = { };
        string step = "";
        double a = values[Flotter.A];
        double b = values[Flotter.B];
        bool has_b = (b != 0);

        step += "%fx".printf(a);

        if (has_b) {
            if (b > 0) {
                step += " +";
            }
            step += " %f".printf(b);
        }

        step += " = 0";
        steps += step;
        step = "";

        // 3x = -1
        if (has_b) {
            step = "%fx = ".printf(a);
            step += "%f".printf(b * -1);
            steps += step;
            step = "";
        }

        if (has_b && b % (a * -1) == 0) {
            step = "S = { %f }".printf(b / (a * -1));
            steps += step;
        } else if (has_b && b % (a * -1) != 0) {
            if ((a < 0 && -b > 0) || (-b < 0 && a > 0)) {
                step = "S = { -%f / %f }".printf((a < 0)? a * -1: a, (b < 0)? b * -1: b);
            } else {
                step = "S = { %f / %f }".printf((a < 0)? a * -1: a, (b < 0)? b * -1: b);
            }
            steps += step;
        } else if (!has_b) {
            step = "S = { 0 }";
            steps += step;
        }

        return steps;
    }

    public string[] get_intercept_as_lineal_step_by_step(double[] values, string? name = null) {
        string[] steps = { };
        string step = "%s(0) = ".printf((name != null)? name: "F");
        double a = values[Flotter.A];
        double b = values[Flotter.B];

        step += "%f·0".printf(a);

        if (b != 0) {
            if (b < 0) {
                step += " %f".printf(b);
            } else {
                step += " + %f".printf(b);
            }
        }

        steps += step;
        steps += "%s(0) = %f".printf((name != null)? name: "F", b);

        return steps;
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

    public string[] solve_as_cuadratic_step_by_step(double[] values) {
        string[] steps = { };
        string step = "";

        double a = values[Flotter.A];
        double b = values[Flotter.B];
        double c = values[Flotter.C];

        step += "%fx^2".printf(a);

        if (b != 0) {
            if (b > 0) {
                step += " +";
            }
            step += " %fx".printf(b);
        }

        if (c != 0) {
            if (c > 0) {
                step += " +";
            }
            step += " %f".printf(c);
        }

        step += " = 0";
        steps += step;
        step = "";

        if (a != 0 && b != 0 && c != 0) {
            // Bhaskara:
            //  -b +- √(b^2 -4ac)
            //  ________________
            //        2a

            double z = GLib.Math.pow(b, 2) - (4 * (a * c));

            steps += "Como a, b y c son distintos a 0, intentamos aplicar bhaskara:";
            steps += "    -b ± √(b² -4ac)";
            steps += "x = _______________";
            steps += "           2a      ";
            steps += "Para eso, <b>b² -4ac</b> debe ser mayor a 0, ya que no existen raices cuadradas de números negativos:";
            steps += "b² -4ac = %f".printf(z);
            if (z >= 0) {
                steps += "Como <b>b² -4ac</b> es mayor a 0 podemos aplicar bhaskara:";

                steps += "      %f ± √(%f² -4·%f·%f)".printf(b * -1, b, a, c);
                step = "x = ________________";

                steps += step;

                steps += "             2·%f      ".printf(a);
                steps += "";

                double z2 = 4 * a * c;
                steps += "    %f ± √%f %s %f".printf(b * -1, GLib.Math.pow(b, 2), (z2 > 0)? "+": "", z2);
                steps += step;

                steps += "         %f         ".printf(2 * a);
                steps += "";

                steps += "%f ± √%f".printf(b * -1, z);
                steps += step;
                steps += "       %f       ".printf(2 * a);
                steps += "";

                steps += "Ahora hay que tomar la raíz positiva y la negativa:";
                steps += "Empezamos con la positiva:";
                steps += "    %f + √%f".printf(b * -1, z);
                steps += "x = ________";
                steps += "       %f   ".printf(2 * a);
                steps += "     %f".printf(b * -1 + GLib.Math.sqrt(z));
                steps += "x = ____";
                steps += "     %f".printf(2 * a);
                steps += " x = %f".printf((b * -1 + GLib.Math.sqrt(z)) / (2 * a));
                steps += "";
                steps += "Seguimos con la raíz negativa:";
                steps += "    %f - √%f".printf(b * -1, z);
                steps += "x = ________";
                steps += "       %f   ".printf(2 * a);
                steps += "     %f".printf(b * -1 - GLib.Math.sqrt(z));
                steps += "x = ____";
                steps += "     %f".printf(2 * a);
                steps += " x = %f".printf((b * -1 - GLib.Math.sqrt(z)) / (2 * a));
                steps += "";
                steps += "S = { %f; %f }".printf((b * -1 + GLib.Math.sqrt(z)) / (2 * a), (b * -1 - GLib.Math.sqrt(z)) / (2 * a));
            } else {
                steps += "Como <b>b² -4ac</b> es menor que 0, no podemos aplicar bhaskara, por lo cual esta función no tiene raices";
                steps += "S = ø";
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

            step = "%fx^2";
            if (b < 0) {
                step += " %fx".printf(b);
            } else {
                step += " + %fx".printf(b);
            }

            step += " = 0";
            steps += step;
            steps += "Podemos factorizar:";
            step = "x (%fx".printf(a);

            if (b < 0) {
                step += " %f)".printf(b);
            } else {
                step += " + %f)".printf(b);
            }

            step += " = 0";
            steps += step;
            steps += "Ahora aplicamos la hankeliana:";
            steps += "x = 0";
            step = "%fx".printf(a);

            if (b < 0) {
                step += " %f".printf(b);
            } else {
                step += " + %f".printf(b);
            }

            steps += step;
            steps += "%fx = %f".printf(a, b * -1);
            steps += "x = %f / %f".printf(b * -1, a);

            if (b * -1 % a == 0) {
                steps += "S = { 0, %f }".printf((b * -1) / a);
            } else {
                steps += "S = { 0, %f / %f }".printf(b * -1, a);
            }
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
                step = "%fx²";

                if (c < 0) {
                    step += " %f".printf(c);
                } else {
                    step += " + %f".printf(c);
                }

                step += " = 0";
                steps += step;
                steps += "%fx² = %f".printf(a, -c);
                steps += "Primera raíz:";
                steps += "%fx = √%f".printf(a, -c);
                steps += "%fx = %f".printf(a, -GLib.Math.sqrt(c));
                steps += "x = %f / %f".printf(-GLib.Math.sqrt(c), a);

                string root1;
                if (-GLib.Math.sqrt(c) % a == 0) {
                    root1 = (-GLib.Math.sqrt(c) / a).to_string();
                    steps += "x = %s".printf(root1);
                } else {
                    root1 = "%f / %f".printf(-GLib.Math.sqrt(c), a);
                }

                steps += "";
                steps += "Segunda raíz:";
                steps += "%fx = √%f".printf(a, -c);
                steps += "%fx = %f".printf(a, GLib.Math.sqrt(c));
                steps += "x = %f / %f".printf(GLib.Math.sqrt(c), a);

                string root2;
                if (GLib.Math.sqrt(c) % a == 0) {
                    root2 = (GLib.Math.sqrt(c) / a).to_string();
                    steps += "x = %s".printf(root2);
                } else {
                    root2 = "%f / %f".printf(GLib.Math.sqrt(c), a);
                }

                steps += "S = { %s; %s }".printf(root1, root2);
            } else {
                step = "%fx^2";

                if (c < 0) {
                    step += " %f".printf(c);
                } else {
                    step += " + %f".printf(c);
                }

                step += " = 0";
                steps += step;
                steps += "%fx² = %f".printf(a, -c);
                steps += "%fx = √%f".printf(a, -c);
                steps += "No existen raices reales para un número negativo";
                steps += "S = ø";
            }
        } else if (a != 0 && b == 0 && c == 0) {
            // Example:
            //   4x^2 = 0
            //   √4x^2 = √0
            //   4x = 0
            //   x = 0
            steps += "%fx² = 0".printf(a);
            steps += "√%fx² = √0".printf(a);
            steps += "%fx = 0".printf(a);
            steps += "Como cualquier número multiplicado por 0 da 0, se dice que la ecuación tiene raíz doble";
            steps += "S = { 0, 0 }";

        } else if (a == 0) {
            return Flotter.solve_as_lineal_step_by_step(values);
        }

        return steps;
    }

    public string[] get_intercept_as_cuadratic_step_by_step(double[] values, string? name = null) {
        string[] steps = { };
        double a = values[Flotter.A];
        double b = values[Flotter.B];
        double c = values[Flotter.C];

        string step = "%s(0) = %f·0²".printf((name != null)? name: "F", a);

        if (b < 0) {
            step += " %f·0".printf(b);
        } else if (b > 0) {
            step += " + %f·0".printf(b);
        }

        if (c < 0) {
            step += " %f".printf(c);
        } else if (c > 0) {
            step += " + %f".printf(c);
        }

        steps += step;
        steps += "%s(0) = %f".printf((name != null)? name: "F", c);

        return steps;
    }

    public double[] solve_as_cubic(double[] values) {
        double x1 = 0;
        double x2 = 0;
        double x3 = 0;

        double a, b, c, d;
        a = values[Flotter.A];
        b = values[Flotter.B];
        c = values[Flotter.C];
        d = values[Flotter.D];

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
    }

    public double[] solve_as_racional(double[] values) {
        double[] solutions = {};

        double a = values[Flotter.A];
        double b = values[Flotter.B];
        double c = values[Flotter.C];
        double d = values[Flotter.D];

        if (a != 0 && b != 0) {
            // Example:
            //  3x - 6
            //  ______ = 0
            //  x + 3
            //
            // 3x - 6 = 0
            // 3x = 6
            // x = 2

            solutions = { -b / a };
        } else if (a != 0 && b == 0 && (c != 0 || d != 0)) {
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
        }

        return solutions;
    }

    public string[] solve_as_racional_step_by_step(double[] values, string? name = null) {
        string[] steps = { };
        string step = "";

        double a = values[Flotter.A];
        double b = values[Flotter.B];
        double c = values[Flotter.C];
        double d = values[Flotter.D];

        step += "%s(x) = ".printf((name != null)? name: "F");

        if (a != 0) {
            steps += "%fx".printf(a);
        }

        if (b > 0 && a != 0) {
            step += " + %f".printf(b);
        } else if (b > 0 && a == 0) {
            step += "%f".printf(b);
        } else if (b < 0 && a != 0) {
            step += " %f".printf(b);
        } else {
            step += "%f".printf(b);
        }

        steps += step;
        steps += "    ________";
        step = "";

        if (c != 0) {
            step += "%fx".printf(c);
        }

        if (d > 0 && c != 0) {
            step += " + %f".printf(d);
        } else if (d > 0 && c == 0) {
            step += "%f".printf(b);
        } else if (d < 0 && c != 0) {
            step += " %f".printf(d);
        } else {
            step += "%f".printf(d);
        }

        steps += step;

        if (a != 0 && b != 0) {
            steps += "Como el único número que al ser dividido da 0, podemos igualar el numerador a 0";
            step = "%fx".printf(a);

            if (b > 0) {
                step += " + %f".printf(b);
            } else if (b < 0 && a != 0) {
                step += " %f".printf(b);
            }

            step += " = 0";
            steps += step;
            steps += "%fx = %f".printf(a, -b);
            steps += "x = %f / %f".printf(-b, a);

            if (-b % a == 0) {
                steps += "x = %f".printf(-b / a);
                steps += "S = { %f }".printf(-b / a);
            } else {
                steps += "S = { %f / %f }".printf(-b, a);
            }
        } else if (a != 0 && b == 0 && (c != 0 || d != 0)) {
            steps += "%fx".printf(a);
            steps += "________ = 0";
            step = "";

            if (c != 0) {
                step = "%fx".printf(c);
            }

            if (d > 0 && c != 0) {
                step += " + %f".printf(d);
            } else if (d < 0) {
                step += "%f".printf(d);
            }

            steps += "Como el único número que al ser dividido da 0, podemos igualar el numerador a 0";
            steps += "%fx = 0".printf(a);
            steps += "x = 0";
            steps += "S = { 0 }";
        }

        return steps;
    }
    
    public string[] get_intercept_as_racional_step_by_step(double[] values, string? name = null) {
        string[] steps = { };
        double a = values[Flotter.A];
        double b = values[Flotter.B];
        double c = values[Flotter.C];
        double d = values[Flotter.D];
        string step = "%s(0) = %f·0²".printf((name != null)? name: "F", a);

        if (a != 0) {
            step += "%f·0 ".printf(a);
        }

        if (b > 0 && a != 0) {
            step += "+ %f".printf(b);
        } else if (b != 0) {
            step += "%f".printf(b);
        }
        
        steps += step;
        steps += "   _________";
        step = "";

        if (c != 0) {
            step += "    %f·0 ".printf(c);
        }

        if (d > 0 && c != 0) {
            step += "+ %f".printf(d);
        } else if (d != 0) {
            step += "%f".printf(d);
        }

        steps += step;
        steps += "";
        steps += "%s(0) = %f / %f".printf((name != null)? name: "F", b, d);

        if (d != 0) {
            if (b % d == 0) {
                steps += "%s(0) = %f".printf((name != null)? name: "F", b / d);
            }
        } else {
            steps += "<b>Las divisiones entre 0 no existen</b>, por lo cual la función no tiene ordenada en el origen.";
        }

        return steps;
    }

    public double[] solve_as_exponential(double[] values) {
        // a^x + b = 0
        // log(a^x) + log(b) = 0
        // (x * log(a)) + log(b) = 0
        // x * log(a) = -log(b)
        // x = -log(b)
        //     _______
        //      log(a)

        double[] solutions = {};

        double a = values[Flotter.A];
        double b = values[Flotter.B];

        solutions = { -GLib.Math.log(b) / GLib.Math.log(a) };

        return solutions;
    }
}
