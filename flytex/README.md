# Racket flyTeX

Install missing TeX Live packages, without bothering too much.


## Installation

```sh
$ raco exe -o ~/.local/bin/flytex flytex.rkt
```

Instead of `~/.local/bin` you can choose any other directory. Just make sure the location you want occurs in `$PATH`. 


## Usage

```sh
$ flytex some-tex.log 
```

