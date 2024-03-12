.PHONY = doc clean uninstall
.RECIPEPREFIX = >

INSTALL_DIR    = $(HOME)/.local/bin
STRELITZIA     = $(INSTALL_DIR)/strelitzia
STRELITZIA_DOC = $(INSTALL_DIR)/strelitzia_readme.pdf

$(STRELITZIA): main.rkt \
	       parsers.rkt \
	       run-shell.rkt \
	       say.rkt \
	       tlmgr.rkt
> raco exe -o $(STRELITZIA) $<

doc: $(STRELITZIA_DOC)

$(STRELITZIA_DOC): README.md
> pandoc -o $(STRELITZIA_DOC) README.md

clean:
> rm -fr compiled

uninstall: clean
> rm -f $(STRELITZIA)
> rm -f $(STRELITZIA_DOC)

