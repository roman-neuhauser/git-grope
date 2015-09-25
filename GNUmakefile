# vim: ft=make ts=8 sts=2 sw=2 noet

PREFIX         ?= /usr/local
BINDIR         ?= $(PREFIX)/bin
MANDIR         ?= $(PREFIX)/share/man
MAN1DIR        ?= $(MANDIR)/man1

CRAMCMD         = cram

GZIPCMD        ?= gzip
INSTALL_DATA   ?= install -m 644
INSTALL_DIR    ?= install -m 755 -d
INSTALL_SCRIPT ?= install -m 755
RST2HTML       ?= $(call first_in_path,rst2html.py rst2html)

SHELL           = $(call first_in_path,zsh)
PATH            = /usr/bin:/bin:/usr/sbin:/sbin

name            = git-grope

programs        = git-grope grope
manpages        = $(programs:%=%.1.gz)

installed       = $(programs) $(manpages)
artifacts       = $(installed) README.html PKGBUILD $(name).spec

revname         = $(shell git describe --always --first-parent)

ALL_INCLUSIVE  ?= 0

.DEFAULT_GOAL  := $(if $(subst 0,,$(ALL_INCLUSIVE)),all,most)

.PHONY: all
all: $(artifacts)

.PHONY: most
most: $(installed)

.PHONY: clean
clean:
	$(RM) $(artifacts)

.PHONY: check
check: $(.DEFAULT_GOAL)
	env -i CRAM="$(CRAM)" PATH="$(PATH)" SHELL="$(SHELL)" $(CRAMCMD) --shell=$(SHELL) tests

.PHONY: html
html: README.html

.PHONY: install
install: $(installed)
	$(INSTALL_DIR) $(DESTDIR)$(BINDIR)
	$(INSTALL_DIR) $(DESTDIR)$(MAN1DIR)
	$(INSTALL_SCRIPT) -t $(DESTDIR)$(BINDIR) $(programs)
	$(INSTALL_DATA) -t $(DESTDIR)$(MAN1DIR) $(manpages)

.PHONY: tarball
tarball: .git
	pkgver=$(fix_version); \
	git archive \
	  --format tar.gz \
	  --prefix $(name)-$${pkgver}/ \
	  --output $(name)-$${pkgver}.tar.gz \
	  HEAD
%.gz: %
	$(GZIPCMD) -cn $< | tee $@ >/dev/null

%.html: %.rest
	$(RST2HTML) --strict $< $@

$(programs): %: %.zsh
	$(INSTALL_SCRIPT) $< $@

%.spec: %.spec.in
	$(call subst_version,^Version:)

PKGBUILD: PKGBUILD.in
	$(call subst_version,^pkgver=)

define subst_version
	pkgver=$(fix_version); \
	sed -e "/$(1)/s/__VERSION__/$$pkgver/" \
	    $< | tee $@ >/dev/null
endef

fix_version = $(subst -,+,$(patsubst v%,%,$(revname)))

define first_in_path
$(or \
  $(firstword $(wildcard \
    $(foreach p,$(1),$(addsuffix /$(p),$(subst :, ,$(PATH)))) \
  )) \
, $(error Need one of: $(1)) \
)
endef

