#lang racket

(require "say.rkt"
         "parsers.rkt"
         "tlmgr.rkt")

(command-line
 ;#:program "flytex"
 #:args (logfile)
 (let ([not-founds (list-not-founds (string->path logfile))])
   (if (empty? not-founds)
       (say "no missing files, fine!")
       (begin
         (say (format "missing files: ~a"
                      (string-join not-founds)))
         (let ([packages-list (tlmgr-list-package-names not-founds)])
           (begin
             (say (format "packages to install: ~a"
                          (string-join packages-list)))
             (unless (tlmgr-install packages-list)
               (say-error "some packages not installed!"))))))))

