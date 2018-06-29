DESTDIR?=/

SOURCES_DIR=src
DTBOS_DIR=overlays

SOURCES:=$(wildcard $(SOURCES_DIR)/*.dtso)
DTBOS:=$(patsubst $(SOURCES_DIR)/%.dtso,$(DTBOS_DIR)/%.dtbo,$(SOURCES))

INSTALL_DEST_DIR=$(DESTDIR)/boot/overlays

all: dtbos

$(DTBOS_DIR):
	mkdir -p $@

dtbos: $(DTBOS)

$(DTBOS_DIR)/%.dtbo: $(SOURCES_DIR)/%.dtso | $(DTBOS_DIR)
	dtc -O dtb -@ -o $@ $^

install: dtbos
	install -m 0755 -d $(INSTALL_DEST_DIR)
	install -m 0644 -t $(INSTALL_DEST_DIR) $(DTBOS)

clean:
	rm -rf $(DTBOS_DIR)

.PHONY: all dtbos install clean
