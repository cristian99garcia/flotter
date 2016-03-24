namespace Flotter {

    public const bool DEBUG = false;  // change to true to show all logs

    public const double[] BG_COLOR = { 0.8, 0.8, 0.8 };
    public const double[] AXES_COLOR = { 0.1, 0.1, 0.1 };
    public const double[] GRID_COLOR = { 0.5, 0.5, 0.5 };
    public const double[] PLOT_COLOR = { 0.8, 0.4, 0.2 };

    public const double STEP = 50;
    public const double AXES_LINE_WIDTH = 4;
    public const double GRID_LINE_WIDTH = 1;
    public const double PLOT_LINE_WIDTH = 2;
    public const double PLOT_SELECTED_LINE_WIDTH = 4;
    public const double GRID_FONT_SIZE = 14;
    public const double NOTABLE_POINT_WIDTH = 5;

    public const int A = 0;
    public const int B = 1;
    public const int C = 2;
    public const int D = 3;
    public const int E = 4;
    public const int F = 4;
    public const int G = 5;

    public const int WIDTH = 0;
    public const int HEIGHT = 1;

    public enum FunctionType {
        NULL,
        CONST,
        LINEAL,
        CUADRATIC,
        CUBIC,
        RACIONAL,
        EXPONENTIAL
    }

    public enum ListViewRowState {
        ACTIVATED,
        DISACTIVATED,
        MOUSE_OVER,
    }
}
