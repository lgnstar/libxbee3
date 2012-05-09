### install rules follow... ###

$(SYS_LIBDIR)/$(LIBNAME).so.$(LIBFULLREV).dbg: $(DESTDIR)/$(LIBNAME).so.$(LIBFULLREV).dbg
	$(INSTALL) -m 755 $^ $@

$(SYS_LIBDIR)/$(LIBNAME).%.$(LIBFULLREV): $(DESTDIR)/$(LIBNAME).%.$(LIBFULLREV)
	$(INSTALL) -m 755 $^ $@

$(SYS_LIBDIR)/$(LIBNAME).%: $(SYS_LIBDIR)/$(LIBNAME).%.$(LIBFULLREV)
	$(SYMLINK) -fs $^ $@

$(addprefix $(SYS_INCDIR)/,$(SYS_HEADERS)): $(SYS_INCDIR)/%: %
	$(INSTALL) -m 644 $^ $@

$(addprefix $(SYS_MANDIR)/,$(addsuffix .gz,$(SYS_MANPAGES))): $(SYS_MANDIR)/%.gz: $(MANDIR)/%
	@echo $(INSTALL) -m 644 $^ $@
	@if [ ! -h $^ ]; then                      \
  $(DEFLATE) < $^ > $@;                      \
  chmod 644 $@;                              \
else                                         \
	$(SYMLINK) -fs $(shell readlink $^).gz $@; \
fi
	chown -h $(SYS_USER):$(SYS_GROUP) $@


### release follows... ###

.PHONY: release

release: $(RELEASE_FILES)
	tar -acf $(LIBNAME)_v$(LIBFULLREV)_`date +%Y-%m-%d`_`git rev-parse --verify --short HEAD`_`uname -m`_`uname -s`.tar.bz2 --transform='s#^#$(LIBNAME)_$(LIBFULLREV)/#SH' $^


### html pages follow... ###

.PHONY: install_html

test:
	@echo $(SYS_HTMLPAGES)

ifeq ($(SYS_HTMLDIR),)
install_html:
	@echo 'Please specify $$(SYS_HTMLDIR) in config.mk'
	@false
else
install_html: $(addprefix $(SYS_HTMLDIR)/,$(SYS_HTMLPAGES))
$(addprefix $(SYS_HTMLDIR)/,$(SYS_HTMLPAGES)): $(SYS_HTMLDIR)/%: $(HTMLDIR)/%
	@echo "$(INSTALL) -m 644 $^ $@"
	@if [ ! -h $^ ]; then                        \
  $(INSTALL) -m 644 $^ $@;                                \
else                                           \
	$(SYMLINK) -fs $(shell readlink $^) $@; \
fi
endif
