.PHONY = clean uninstall
.RECIPEPREFIX = >

INSTALL_DIR = $(HOME)/.local/bin
STRELITZIA = $(INSTALL_DIR)/strelitzia

$(STRELITZIA): main.rkt parsers.rkt run-shell.rkt say.rkt tlmgr.rkt
> raco exe -o $(STRELITZIA) $<

clean:
> rm -fr compiled

uninstall:
> rm $(STRELITZIA)
