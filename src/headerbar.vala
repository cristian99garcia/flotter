namespace Flotter {

    public class HeaderBar: Gtk.HeaderBar {

        public signal void save();

        public Gtk.Button save_button;

        public HeaderBar() {
            this.set_show_close_button(true);
            this.set_title("Flotter");

            this.save_button = new Gtk.Button();
            this.save_button.set_image(new Gtk.Image.from_icon_name("document-save-symbolic", Gtk.IconSize.BUTTON));
            this.save_button.clicked.connect(() => { this.save(); });
            this.pack_end(this.save_button);
        }
    }
}
