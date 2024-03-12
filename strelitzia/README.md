---
documentclass: article
header-includes:
- \usepackage[rm,tt=false]{libertine}
- \usepackage{microtype}
---

# Strelitzia

Suppose you have installed a [minimal TeX Live](https://github.com/indrjo/minimal-texlive-installer.git) and you want to produce your document via, say,

``` sh
$ pdflatex main.tex
```

It probably won't work owing to missing packages from your TeX Live. It is a work for `strelitzia`:

``` sh
$ strelitzia main.tex
```

*Strelitzia* coordinates a couple of actors: while it runs `pdflatex main.tex`, it extracts from the log the names of the missing files, invokes *tlmgr* to determine the parent packages and makes *tlmgr* install them. How the command `pdflatex main.tex`terminates (zero o non-zero exit code) is not relevant to the program.

**(Warning)** The dependencies of TeX Live are a hell: that means you may have to run *strelitzia* more than once to get all dependencies satisfied.

Once your ecosystem is enough for your work, you can go back to using `pdflatex` as you are used to.


## Usage

``` sh
$ strelitzia -e TEX_ENGINE FILE.tex
```

If you omit the part `-e TEX_ENGINE`, then the program will assume `TEX_ENGINE` equal to `pdflatex`. (Some values for `TEX_ENGINE` are `pdflatex`, `lualatex`, `xelatex` and so on... Make sure binaries can be found in one of the directories in `PATH`.)

Always refer to `strelitzia --help`, because for the moment the program and the cli interface change faster than this documentation.


## Installation

The program is written in [Racket](https://racket-lang.org). One module that may not be installed is `parsack`; install it if needed:

``` sh
$ raco pkg install parsack
```

Then choose a directory, for example `~/.local/bin`, and use `raco` to create an executable as follows:

``` sh
$ raco exe -o ~/.local/bin/strelitzia main.rkt
```

Instead of `~/.local/bin` you can choose any other directory. Just make sure the location you want occurs in `$PATH`.

