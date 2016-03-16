namespace Flotter {

    public class App: Gtk.Application {

        public App() {
        }

        protected override void activate() {
            this.window_removed.connect(this.window_removed_cb);
            this.new_window();
        }

        private void window_removed_cb(Gtk.Application self, Gtk.Window window) {
            if (this.get_windows().length() == 0) {
                this.quit();
            }
        }

        public void new_window() {
            Flotter.Window win = new Flotter.Window();
            win.set_application(this);
            this.add_window(win);
        }
    }
}

void main(string[] args) {
    var app = new Flotter.App();
    app.run();
}
