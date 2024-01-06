# Strelitzia

Suppose you have installed a [minimal TeX Live](https://github.com/indrjo/minimal-texlive-installer.git) and you want to produce your document via, say,

``` sh
$ pdflatex main.tex
```

It probably won't work owing to missing packages from your TeX Live. It is a work for `strelitzia`:

``` sh
$ strelitzia main.tex
```

It will try to create the corresponding document: any missing but required package will be installed right away. 


## Usage

``` sh
$ strelitzia --engine TEX_ENGINE FILE.tex
```

If you omit the part `--engine TEX_ENGINE`, then the program will assume `TEX_ENGINE` being `pdflatex`. Some values for `TEX_ENGINE` are `pdflatex`, `lualatex`, `xelatex` and so on...


## Installation

The program is written in Racket. One module that may not be installed is `parsack`; install it if needed:

``` sh
$ raco pkg install parsack
```

Then choose a directory, for example `~/.local/bin`, and use `raco` to create an executable as follows:

``` sh
$ raco exe -o ~/.local/bin/strelitzia main.rkt
```

Instead of `~/.local/bin` you can choose any other directory. Just make sure the location you want occurs in `$PATH`.

