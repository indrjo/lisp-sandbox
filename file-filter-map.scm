#lang racket

(provide file-filter-map)

;; Take a sequence: keep only the elements satisfying some propert; then
;; apply a function to each of those elements.
(define (sequence-filter-map p f seq)
  (sequence-map f (sequence-filter p seq)))

;; As above, but in place of a sequence, there is a file.
(define (file-filter-map line-pred line-func fname)
  (call-with-input-file fname
    (λ (in)
     (sequence->list
      (sequence-filter-map line-pred line-func (in-lines in))))))
