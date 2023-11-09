#lang racket

(provide list-package-names
         list-not-founds)

(require parsack)

;;
;; DESCRIPTION
;;
;; This module defines some parsers that are required by other modules.
;;

;; ************************************************************************
;; Parse `tlmgr search --global --file` output
;; ************************************************************************

;; In substrings of the form "\npkg-name:\n" extract "pkg-name".
(define package-name-parser
  (>> (string "\n")
      (>>= (many (noneOf ":"))
           (λ (name)
             (>> (string ":\n")
                 (return (list->string name)))))))

;; Return the list of the package names using `package-name-parser`.
(define package-names-parser
  (choice
   (list
    (>> $eof
        (return '()))
    (try (>>= package-name-parser
              (λ (name)
                (>>= package-names-parser
                     (λ (names)
                       (return (cons name names)))))))
    (>>= $anyChar
         (λ (_) package-names-parser)))))

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
    (>> $eof
        (return '()))
    (try (>>= not-found-parser
              (λ (name)
                (>>= not-founds-parser
                     (λ (others)
                       (return (cons name others)))))))
    (>>= $anyChar
         (λ (_) not-founds-parser)))))

(define list-not-founds
  (curry parse-result not-founds-parser))

