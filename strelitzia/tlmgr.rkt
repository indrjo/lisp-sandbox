#lang racket

(provide tlmgr-list-package-names
         tlmgr-install
         contact-package-repo)

(require "run-shell.rkt"
         "parsers.rkt")

;;
;; DESCRIPTION
;;
;; Functions that run `tlmgr` under the hood.
;;

;; ************************************************************************
;; Search for packages to install
;; ************************************************************************

;; Take a list of file names (namely, the ones that are missing) and return
;; the shell command to be issued to the host system.
(define (tlmgr-search-command names)
  (format "tlmgr search --global --file '/(~a)'" (string-join names "|")))

;; Get the list of the packages corresponding to a list of filenames.
(define (tlmgr-list-package-names names)
  (list-package-names (process-output (tlmgr-search-command names))))


;; ************************************************************************
;; Install packages
;; ************************************************************************

;; Install all the packages in a given list.
(define (tlmgr-install packages)
  (system (format "tlmgr install ~a" (string-join packages))))


;; ************************************************************************
;; See if you can contact the package repository
;; ************************************************************************

(define (wget-spider url)
  (system (format "wget -q --spider '~a'" url)))

(define (contact-package-repo)
  (wget-spider (repo-url (process-output "tlmgr option repository"))))

