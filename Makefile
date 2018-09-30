# This script was tested using emcripten version 1.37.36.

TOOLS = emcc emconfigure emcmake
$(foreach tool, $(TOOLS),\
	$(if $(shell which $(tool) 2> /dev/null), ,\
		$(error "No $(tool) found in PATH. Please install Emscripten framework")))



ARCHIVES_DIR = archives
BUILD_DIR = build
DIST_DIR = dist

POPT_BUILD_DIR = $(BUILD_DIR)/popt
SVOX_BUILD_DIR = $(BUILD_DIR)/svox
PICO_BUILD_DIR = $(BUILD_DIR)/svox/pico



POPT_ARCHIVE = $(ARCHIVES_DIR)/popt.tar.gz
$(POPT_ARCHIVE): ARCHIVE_URL = http://snapshot.debian.org/archive/debian/20100513T095853Z/pool/main/p/popt/popt_1.16.orig.tar.gz
$(POPT_ARCHIVE): ARCHIVE_SHA256SUM = e728ed296fe9f069a0e005003c3d6b2dde3d9cad453422a10d6558616d304cc8

SVOX_ARCHIVE = $(ARCHIVES_DIR)/svox.tar.gz
$(SVOX_ARCHIVE): ARCHIVE_URL = http://snapshot.debian.org/archive/debian/20130725T154524Z/pool/non-free/s/svox/svox_1.0%2Bgit20130326.orig.tar.gz
$(SVOX_ARCHIVE): ARCHIVE_SHA256SUM = 337b25e6ccb3764f0df1e176470b883c90e40e98840d4133340fcc89eb3cea0c

SVOX_DEB_ARCHIVE = $(ARCHIVES_DIR)/svox-debian.tar.gz
$(SVOX_DEB_ARCHIVE): ARCHIVE_URL = http://snapshot.debian.org/archive/debian/20160911T044636Z/pool/non-free/s/svox/svox_1.0%2Bgit20130326-5.debian.tar.xz
$(SVOX_DEB_ARCHIVE): ARCHIVE_SHA256SUM = ec92d021b99f0501fa01b67db77cad5c350d726ec6faaa6378e0c6396a14d13b



PICO2WAVE = $(DIST_DIR)/pico2wave.js

MODULE_FLAGS  = -Oz --memory-init-file 0 -s MODULARIZE=1
MODULE_FLAGS += -s NO_EXIT_RUNTIME=1 -s ASSERTIONS=0
MODULE_FLAGS += -s 'EXTRA_EXPORTED_RUNTIME_METHODS=["FS"]'
MODULE_FLAGS += -s 'EXPORT_NAME="Pico2wave"'

PICO_OBJECTS  = $(PICO_BUILD_DIR)/pico2wave-pico2wave.o
PICO_OBJECTS += $(PICO_BUILD_DIR)/.libs/libttspico.a
POPT_OBJECTS = $(POPT_BUILD_DIR)/.libs/libpopt.a

# en-GB
EMBED_FILES  = --embed-file $(PICO_BUILD_DIR)/lang/en-GB_kh0_sg.bin@/usr/local/share/pico/lang/en-GB_kh0_sg.bin
EMBED_FILES += --embed-file $(PICO_BUILD_DIR)/lang/en-GB_ta.bin@/usr/local/share/pico/lang/en-GB_ta.bin

# en-US
EMBED_FILES += --embed-file $(PICO_BUILD_DIR)/lang/en-US_lh0_sg.bin@/usr/local/share/pico/lang/en-US_lh0_sg.bin
EMBED_FILES += --embed-file $(PICO_BUILD_DIR)/lang/en-US_ta.bin@/usr/local/share/pico/lang/en-US_ta.bin

# fr-FR
EMBED_FILES += --embed-file $(PICO_BUILD_DIR)/lang/fr-FR_nk0_sg.bin@/usr/local/share/pico/lang/fr-FR_nk0_sg.bin
EMBED_FILES += --embed-file $(PICO_BUILD_DIR)/lang/fr-FR_ta.bin@/usr/local/share/pico/lang/fr-FR_ta.bin



all: $(PICO2WAVE)


$(PICO2WAVE): $(PICO_OBJECTS) $(POPT_OBJECTS)
	mkdir -p $(DIST_DIR)
	emcc $(MODULE_FLAGS) $(EMBED_FILES) $^ -o $@


$(PICO_OBJECTS): $(POPT_OBJECTS) $(SVOX_ARCHIVE) $(SVOX_DEB_ARCHIVE)
	mkdir -p $(SVOX_BUILD_DIR)
	tar -xvf $(SVOX_ARCHIVE) -C $(SVOX_BUILD_DIR) --strip-components=1
	tar -xvf $(SVOX_DEB_ARCHIVE) -C $(SVOX_BUILD_DIR) --strip-components=1
	cd $(SVOX_BUILD_DIR) && \
		for i in patches/*.patch; do patch -p1 < $$i; done
	cd $(PICO_BUILD_DIR) && \
		chmod +x autogen.sh && \
		emconfigure ./autogen.sh && \
		emconfigure ./configure CFLAGS="-I../../popt -L../../popt/.libs -L.libs" && \
		emcmake make


$(POPT_OBJECTS): $(POPT_ARCHIVE)
	mkdir -p $(BUILD_DIR)/popt
	tar -xvf $(POPT_ARCHIVE) -C $(POPT_BUILD_DIR) --strip-components=1
	cd $(POPT_BUILD_DIR) && \
		emconfigure ./configure CFLAGS="-L.libs" && \
		emcmake make


%.tar.gz:
	@echo "Downloading $@"
	@mkdir -p $(ARCHIVES_DIR)
	@rm -f $@.tmp
	@curl $(ARCHIVE_URL) -o $@.tmp
	$(eval SHA256SUM=`sha256sum $@.tmp | cut -d ' ' -f1`)
	@if [ $(SHA256SUM) = $(ARCHIVE_SHA256SUM) ] ; then \
		mv $@.tmp $@; \
	else \
		rm $@.tmp && \
		@echo "Invalid checksum for $@" && \
		exit 1; \
	fi


clean:
	rm -rf $(ARCHIVES_DIR) $(BUILD_DIR) $(PICO2WAVE)
