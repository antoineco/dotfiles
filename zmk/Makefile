.PHONY: all
all: totem_left.uf2 totem_right.uf2

.PHONY: init
init:
	west init -l config/
	west update
	west zephyr-export

%.uf2: config/totem.keymap config/totem.conf config/%.conf config/mouse.h
	west build -p -s zmk/app -d build/$* -b seeeduino_xiao_ble -- -DZMK_CONFIG=$(CURDIR)/config -DSHIELD=$*
	cp build/$*/zephyr/zmk.uf2 $@

.PHONY: clean
clean:
	rm -rvf build/
	rm -vf *.uf2
