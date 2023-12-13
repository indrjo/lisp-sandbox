#lang racket

(provide list-package-names
         list-not-founds
         repo-url)

(require parsack)

;;
;; DESCRIPTION
;;
;; This module defines some parsers that are required by other modules.
;;

;; ************************************************************************
;; Parse `tlmgr search --global --file` output
;; ************************************************************************

;; In the substrings of the form "\npkg-name:\n" extract "pkg-name".
(define package-name-parser
  (between $newline
           (>> (string ":") $newline)
           (>>= (many1 (noneOf ":"))
                (compose return list->string))))

;; Return the list of the package names using `package-name-parser`.
(define package-names-parser
  (choice
   (list
    (try (>>= package-name-parser
              (λ (name)
                (>>= package-names-parser
                     (λ (others)
                       (return (cons name others)))))))
    (try (>>= $anyChar
              (λ (_) package-names-parser)))
    (return '()))))

(define list-package-names
  (curry parse-result package-names-parser))


;; ************************************************************************
;; Parse TeX logs to get the names of the missing files
;; ************************************************************************

;; The list of marks used to quote in strings.
(define quote-marks "'\"`")

;; From a string of the form "<quote-mark>name<quote-mark>" give "name".
(define quoted-name-parser
  (between (oneOf quote-marks)
           (oneOf quote-marks)
           (many1 (noneOf quote-marks))))

;; From "<quote-mark>file-name<quote-mark> not found", return "file-name".
(define not-found-parser
  (>>= quoted-name-parser
       (λ (name)
         (>> (>> $spaces
                 (string "not found"))
             (return (list->string name))))))

;; List all the files not found by repeatedly applying `not-found-parser`.
(define not-founds-parser
  (choice
   (list
    (try (>>= not-found-parser
              (λ (name)
                (>>= not-founds-parser
                     (λ (others)
                       (return (cons name others)))))))
    (try (>>= $anyChar
              (λ (_) not-founds-parser)))
    (return '()))))

(define list-not-founds
  (curry parse-result not-founds-parser))


;; ************************************************************************
;; Parse `tlmgr option repository` output
;; ************************************************************************

(define repo-url-parser
  (>> (>> (string "Default package repository (repository):")
          $spaces)
      (>>= (many1 (noneOf "\n "))
           (compose return list->string))))

(define repo-url
  (curry parse-result repo-url-parser))

