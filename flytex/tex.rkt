#lang racket

(provide tex-command)

(define (tex-command engine main-file)
  (string-join (list "perl -e 'print \"\n\"x50' |"
                     "max_print_line=1000" engine main-file)))

