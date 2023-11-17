#lang racket

(require "say.rkt"
         "tex.rkt"
         "parsers.rkt"
         "tlmgr.rkt")

;; The main program is a function that accepts two arguments:
;;
;; * The former argument is a string containing the name of the TeX engine
;;   to be used. The program relies on PATH to find the binaries: hence
;;   if you do not have the location containing them in PATH, you should
;;   write the TeX engine with the full path to it. 
;;
;; * The latter is the name of the TeX file to be given to the TeX engine.
;;   Make sure to run flytex within the directory of the file.
(define (main-program engine texfile)
  ;; Try to compile the main TeX file.
  (make-tex (tex-engine) texfile)
  ;; Now parse the generated log, and install any required package.
  (let* ([logfile (path-replace-extension texfile ".log")]
         [not-founds (list-not-founds logfile)])
    (if (empty? not-founds)
        (say "no missing files, fine!")
        (begin
          (say (format "missing files: ~a"
                       (string-join not-founds)))
          (if (contact-package-repo)
              (let ([packages (tlmgr-list-package-names not-founds)])
                (begin
                  (say (format "packages to install: ~a"
                               (string-join packages)))
                  (unless (tlmgr-install packages)
                    (say-error "some packages not installed!"))))
              (say-error "cannot contact the package repo!"))))))

;; The TeX engine. It defaults to pdflatex; you can modify it with
;; `--engine TEX_ENGINE` or `-e TEX_ENGINE`.
(define tex-engine (make-parameter "pdflatex"))

(command-line
 #:program "flytex"
 #:once-each
 [("--engine" "-e")
  this-instead
  "Choose a TeX engine to be used [default: pdflatex]"
  (tex-engine this-instead)]
 #:args (texfile)
 (main-program (tex-engine) texfile))

