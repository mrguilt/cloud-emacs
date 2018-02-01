;;;.emacs for Mobile Workstations
;;;Created 2014-06-19
;;;Updated 2018-01-31
;;;Basically, the idea is to have as few machine-specific calls here, then
;;;hand off to a shared file "in the cloud."
;;;
;;;This version is designed to have a local version of the cloud directory.
;;;It checks to see if the cloud version (which should be the most up-to-
;;;date) is available. It will use that if it's availble. If not, it will
;;;fail to the local copy (which may-or-may-not be up-to-date).
;;;
;;;This is meant for systems that may not connect to the cloud/shared drive
;;;such as laptops.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Setup calls for Mobile Workstations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;Creates a variable pointing to where the cloud directory appears on 
;;;this machine.
;;;Classic setup. Retained just in case. 

;;;This version checks to see if the cloud drive is mounted. If it is,
;;;that is the cloud directory. If not, is uses the replica Windows made.
(if (file-exists-p "~/box/elisp")
    (setq cloud-dir "~/box/elisp")	;;;The version in the cloud
    (setq cloud-dir "/media/data/users/chbarr/Box/Box Sync/elisp")	;;;Local version 
    )
(print cloud-dir)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Hand-off to shared "dot-emacs" file (dot.emacs.el)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Where's my personal elisp stuff?
(add-to-list 'load-path cloud-dir)
(load-library "dot.emacs")


