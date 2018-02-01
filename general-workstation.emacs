;;;.emacs for Workstation (General)
;;;Created 2014-06-19
;;;Updated 2018-01-31
;;;Basically, the idea is to have as few machine-specific calls here, then
;;;hand off to a shared file "in the cloud."

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Machine-Specific Calls for caracal, the WorkTop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;Creates a variable pointing to where the cloud directory appears on 
;;;this machine.
(setq cloud-dir "~/box/elisp")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Hand-off to shared "dot-emacs" file (dot.emacs.el)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Where's my personal elisp stuff?
(add-to-list 'load-path cloud-dir)
(load-library "dot.emacs")





