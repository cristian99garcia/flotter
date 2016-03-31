SRC = src/flotter.vala \
      src/window.vala \
      src/area.vala \
      src/entry.vala \
      src/list_view.vala \
      src/save_dialog.vala \
      src/help_dialog.vala \
      src/brain.vala \
      src/utils.vala \
      src/consts.vala

      #src/headerbar.vala \

PKG = --pkg gtk+-3.0

OPTIONS = -X -lm

BIN = flotter

all:
	valac $(PKG) $(SRC) $(OPTIONS) -o $(BIN)

