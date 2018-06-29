DESTDIR?=/

SOURCES_DIR=src
DTBOS_DIR=overlays

Q=@

dtc_cpp_flags = -nostdinc -undef -D__DTS__ -I$(SOURCES_DIR)
DTC_FLAGS = -Wno-unit_address_vs_reg

SOURCES:=$(wildcard $(SOURCES_DIR)/*.dtso)
DTBOS:=$(patsubst $(SOURCES_DIR)/%.dtso,$(DTBOS_DIR)/%.dtbo,$(SOURCES))

INSTALL_DEST_DIR=$(DESTDIR)/boot/overlays

all: dtbos

$(DTBOS_DIR):
	$(Q)echo " [MKDIR] $@"
	$(Q)mkdir -p $@

dtbos: $(DTBOS)

$(DTBOS_DIR)/%.dtbo: $(SOURCES_DIR)/%.dtso | $(DTBOS_DIR)
	$(Q)echo " [DTB] $<"
	$(Q)cat $< | \
		$(CPP) $(dtc_cpp_flags) -x assembler-with-cpp - | \
		dtc -I dts -O dtb -@ -o $@ $(DTC_FLAGS)

install: dtbos
	install -m 0755 -d $(INSTALL_DEST_DIR)
	install -m 0644 -t $(INSTALL_DEST_DIR) $(DTBOS)

clean:
	rm -rf $(DTBOS_DIR)

.PHONY: all dtbos install clean
