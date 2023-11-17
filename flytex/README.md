# Racket flyTeX

Suppose you have installed a *minimal TeX Live* and you want to produce your document via, say,

``` sh
$ pdflatex main.tex
```

It probably won't work owing to missing packages from your TeX Live. It is a work for `flytex`:

``` sh
$ flytex main.tex
```

It will try to create the corresponding document: any missing but required package will be installed right away. 


## Usage

``` sh
$ flytex --engine TEX_ENGINE FILE.tex
```

If you omit the part `--engine TEX_ENGINE`, then the program will assume `TEX_ENGINE` being `pdflatex`. Some values for `TEX_ENGINE` are `pdflatex`, `lualatex`, `xelatex` and so on...


## Installation

First of all, install `parsack`:

``` sh
$ raco pkg install parsack
```

To install just decide a directory, for example `~/.local/bin`, and use `raco` as follows:

``` sh
$ raco exe -o ~/.local/bin/flytex flytex.rkt
```

Instead of `~/.local/bin` you can choose any other directory. Just make sure the location you want occurs in `$PATH`. 


## Usage

``` sh
$ flytex some-tex.log 
```

