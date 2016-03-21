namespace Flotter {

    public class SaveDialog: Gtk.Window {

        public Gtk.Box vbox;
        public Gtk.Box hbox;
        public Gtk.Image image;
        public Flotter.Area area;

        public SaveDialog(Flotter.Area area) {
            this.set_title("Guardar");
            this.set_modal(true);
            this.set_border_width(10);

            this.area = area;

            this.vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            this.add(this.vbox);

            this.hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            this.vbox.pack_start(this.hbox, false, false, 0);

            this.image = new Gtk.Image();
            this.image.set_size_request(240, 200);
            this.hbox.pack_start(this.image, false, false, 0);

            this.show.connect(this.show_cb);
            this.delete_event.connect(this.delete_cb);
        }

        private void show_cb(Gtk.Widget self) {
            Gtk.Allocation alloc;
            this.image.get_allocation(out alloc);

            Gdk.Pixbuf pixbuf = this.area.get_pixbuf();
            int min = int.min(pixbuf.get_width(), pixbuf.get_height());
            int width = pixbuf.get_width() / alloc.width * min;
            int height = pixbuf.get_height() / alloc.height * min;

            pixbuf = pixbuf.scale_simple(width, height, Gdk.InterpType.HYPER);
            this.image.set_from_pixbuf(pixbuf);
        }

        private bool delete_cb(Gtk.Widget self, Gdk.EventAny event) {
            this.hide();
            return true;
        }
    }
}
