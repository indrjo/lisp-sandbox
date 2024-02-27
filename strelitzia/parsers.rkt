#lang racket

(provide list-package-names
         list-not-founds
         extract-repo-url)

(require parsack)

;;
;; DESCRIPTION
;;
;; This module defines some parsers that are required by other modules.
;;


;; ************************************************************************
;; Helper functions
;; ************************************************************************

;; While consuming the input string, try a given parser: if it succeeds,
;; collect the match into a list, otherwise move on by one character.
(define (list-captures-parser p)
  (<or>
   (try (>>= p
             (λ (str)
               (>>= (list-captures-parser p)
                    (λ (strs)
                      (return (cons (list->string str) strs)))))))
   (try (>>= $anyChar
             (λ (_)
               (list-captures-parser p))))
   (return '())))

;; Observe that the parser above never fails: thus you can always expect
;; `(parse-result (list-captures-parser p) input)` to return a list and not
;; throw an exception.
(define (list-captures p input)
  (parse-result (list-captures-parser p) input))


;; ************************************************************************
;; Parse `tlmgr search --global --file` output
;; ************************************************************************

;; From "\nNAME:\n" extract "NAME".
(define package-name-parser
  (between $newline
           (>> (string ":") $newline)
           (many1 (noneOf ":"))))

;; From the output of `tlmgr search --global --file PATTERN` list the names
;; the names of the packages that occur.
(define (list-package-names input)
  (list-captures package-name-parser input))


;; ************************************************************************
;; Parse TeX logs to get the names of the missing files
;; ************************************************************************

(define quote-marks "'\"`")

(define quoted-name-parser
  (between (oneOf quote-marks)
           (oneOf quote-marks)
           (many1 (noneOf quote-marks))))

;; The fragment between two quotation marks.
(define not-found-parser
  (>>= quoted-name-parser
       (λ (name)
         (>> (>> $spaces
                 (string "not found"))
             (return name)))))

;; Capture the names the missing files from the log of a TeX command. More
;; precisely, look for pieces of the form
;;
;;   "FILE" not found
;;
;; and isolate FILE.
(define (list-not-founds input)
  (parse-result (list-captures-parser not-found-parser) input))


;; ************************************************************************
;; Parse `tlmgr option repository` output
;; ************************************************************************

(define repo-url-parser
  (>> (>> (string "Default package repository (repository):")
          $spaces)
      (>>= (many1 (noneOf "\n "))
           (compose return list->string))))

;; Try to parse the output of `tlmgr option repository`. If success, then
;; return the url, otherwise return #f.
(define (extract-repo-url input)
  (with-handlers ([exn:fail:parsack? (λ (_) #f)])
    (parse-result repo-url-parser input)))

