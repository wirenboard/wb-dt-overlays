DESTDIR?=/

SOURCES_DIR=src
DTBOS_DIR=overlays

SOURCES:=$(wildcard $(SOURCES_DIR)/*.dtso)
DTBOS:=$(patsubst $(SOURCES_DIR)/%.dtso,$(DTBOS_DIR)/%.dtbo,$(SOURCES))

INSTALL_DEST_DIR=$(DESTDIR)/boot/overlays

$(DTBOS_DIR):
	mkdir $@

all: dtbos

dtbos: $(DTBOS)

$(DTBOS_DIR)/%.dtbo: $(SOURCES_DIR)/%.dtso | $(DTBOS_DIR)
	dtc -O dtb -@ -o $@ $^

install: dtbos
	install -m 0755 -d $(INSTALL_DEST_DIR)
	install -m 0644 -t $(INSTALL_DEST_DIR) $(DTBOS)

clean:
	rm -rf $(DEST_DIR)

.PHONY: all dtbos install clean
