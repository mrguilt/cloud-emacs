;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Shared dot-emacs
;;;
;;;This is the .emacs file that will be shared among all systems. 
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			      REFERENCE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;	     Elisp system-name Output for Active Systems
;;;
;;; Personal/Local Systems
;;; -------------- -------
;;; WorkTop Hostname=CPX-0QIOUDXB0GL (2017-07-24)
;;; New HP laptop="kingswood"
;;; Windows VM on MacBook="SERVAL"
;;; Raspberry Pi Zero="squip"
;;;
;;; Remote Systems
;;; ------ -------
;;; AWS Server ("spectr-temp" in DNS)="ip-172-31-128-206.ec2.internal"
;;; Google Cloud Server ("spectr" in DNS)="ip-172-31-128-206-b897bb0a.c.promising-howl-161512.internal"
;;; SDF Free UNIX="sdf", "faeroes", "iceland", "miku", "otaku", and  
;;;               "norge" (round robin assignment at login to tty.sdf.org)
;;; hashbang="da1.hashbang.sh"
;;; Tilde.Town="tilde.town"
;;; grex.org="grex.org"
;;;
;;; Cloud Directoy is currently on Box.com. (2017-07-27)
;;; SDF and hashbang do not support Cloud Directory.

(print "We're kicked off dot.emacs.el!")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;		       ACTUAL CODE BEGINS HERE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Print some useful stuff
(print "System Information")
(print (concat "System Name: " system-name))
(print system-type)
(print (concat "EMACS Version: " emacs-version))
(print "dot.emacs.el file last updated 2018-01-25.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; In an effort for "one dot-emacs to rule them all," I'm creating a
;;; variable called "clouddir-packages-available." The assumption is that
;;; most systems will either be referencing the cloud directory on box
;;; (or other provider as I see fit), or I'll be able to install packages
;;; locally (and replicate dot.emacs as needed).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar clouddir-packages-available t
  "Works with my model of storing elisp, et al., in the cloud. Tests in scripts (such as dot.emacs) can incldue or exclude based on that. Default is true.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Creating an insert-signature command of my own design. Setting
;;; a default here, but making it such that it can change based on machine.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar sigfile "~/.signature"
	"Location and name of the signature file on the machine. Default is ~/.signature")

;;; The actual sign-it command. 
(defun sign-it ()
  "Insert a signature file at the end of the buffer."
  (interactive)
  (goto-char (point-max))
  (insert "\n")
  (insert-file sigfile)
  (goto-char (point-min))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Platform-specific check. These can be overwritten per machine if need
;;; be (for instance, if bash isn't at /bin/bash).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (eq system-type 'windows-nt)
  (progn
    (print "Windows system")
;mulit-term doesn't seem to want to work in windows. still thinking about it.
    (setq shellprog "C:/windows/system32/cmd.exe")
    )
  
  (progn
    (print "not windows")
    (setq shellprog "/bin/bash")
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setting Up Machine-Specific Environment (fonts, colors, etc.)
;;;
;;; (This may get moved to the local .emacs file)
;;;
;;; The goal of this was to have one place for all variables. However,
;;; there are some things that are clearly machien dependent. With a few
;;; exceptions, they are fonts, colors, and terminal settings. But there
;;; are a few settings that might vary otherwise--can we use a cloud drive,
;;; location of signature file, etc. I can't decide how to handle the
;;; not display stuff. Thoughts:
;;; 1. Go back to putting all that in .emacs for fonts, terminal settings,
;;;    and unique variables. dot.emacs.el becomes just for univeral
;;;    things like file extension associations.
;;; 2. Original approach of an if-then loop for graphic or not, then test
;;;    for machine. Machine specific stuff goes in the latter test. For
;;;    the most part, either I use the GUI EMACS *or* terminal EMACS on a
;;;    given system, so it works. The one or two machines where I go both
;;;    ways need to have two tests (one in the terminal and one in the non-
;;;    terminal machine test). I'll have to replicate machine settings
;;;    not related to GUI/terminal at both.
;;; 3. See if terminal versions will ignore GUI settings (fonts, etc.) and
;;;    just do the machien test. (nope)
;;; 4. Do #2, but, instead of replicating for systems that go both ways,
;;;    just have machine tests for them.
;;;
;;; My strategy will be #2 unless it becomes too messy. 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Some things only work if I'm using a GUI. Let's not have error messages
(if (display-graphic-p)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;General things for the GUI
    (progn
      (print "It's a GUI!")
      ;;;General GUI Stuff
      (tool-bar-mode -1) ;Turn Off Toolbar
      (set-fringe-mode '(0 . 0)) ;;;Turn off that stupid fringe BS.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Machine-Specific things for the GUI
      
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;;; Things for the WorkTop
      (if (string= system-name "CPX-0QIOUDXB0GL")
	  (progn
	    (print "It's the WorkTop!")
	    (set-face-attribute 'default nil :font "Consolas")		    
	    (set-face-attribute 'default (selected-frame) :height 140) ;;;Make the typeface a bit bigger (120%). 
	    (set-background-color "#FFFFCC")
	    (cd "c:/Users/i.charles.barilleaux/Box Sync/")
	    (setq sigfile "~/signature.txt")
	    ))

      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;;; Things for the Raspberry Pi (squip)
      (if (string= system-name "squip")
	  (progn
	    (print "It's the Raspberry Pi!")
;;; 	    (set-face-attribute 'default nil :font "Consolas")
	    (set-background-color "#A9F5A9")
	    (set-face-attribute 'default (selected-frame) :height 140) ;;;Make the typeface a bit bigger (120%). 
	    ))
      ;;; Things for Kingswood (HP Omen)
;;;      (if (string= system-name (or "kingswood" "KINGSWOODW"))
      (if (or (string= system-name "kingswood") (string= system-name "KINGSWOODW"))
	  (progn
	    (print "It's Kingswood!")
	    (set-face-attribute 'default nil :font "Liberation Mono")
;;;	    (set-face-attribute 'default nil :font "DEC Terminal Modern")
	    (set-face-attribute 'default (selected-frame) :height 150) ;;;Make the typeface a bit bigger (150%). 	    
	    (set-background-color "#fcf8e1")
	    ))
      )
;;; else 
;;; Things for terminal mode
	(progn 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; General Terminal Stuff
	  (print "It's a Terminal")
	  (menu-bar-mode -1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Machine-Specific terminal stuff
	  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  ;;; AWS Spectr-Temp (old mail server)
	  (if (string= system-name "ip-172-31-128-206.ec2.internal")
	  (progn
	    (print "AWS System IN THE CLOUD!")
	    ;; disable color highlighting (for now)--makes things confussing.
	    (global-font-lock-mode 0)
	    ))

	  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  ;;; spectr
	  (if (string= system-name "ip-172-31-128-206-b897bb0a.c.promising-howl-161512.internal")
	  (progn
	    (print "Google Cloud system (specr.mrguilt.com).")
          ))


	  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  ;;; Wintermute, the "Floating" Pi Zero
	  (if (string= system-name "wintermute")
	  (progn
	    (print "Wintermute (the floating Pi), Terminal")
	    ;; disable color highlighting (for now)--makes things confussing.
	    (global-font-lock-mode 0)
	    ))


	  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  ;;; SDF, which doesn't support cloud drives.
	  (if (member system-name '("sdf" "faeroes" "iceland" "miku" "norge" "otaku"))
	  (progn
	    (print "A SDF Free UNIX server")
            ;;; This doesn't work with cloud drive, so swap the variable.
	    (setq clouddir-packages-available 'nil)
	    (add-to-list 'load-path "~/emacs.d")
	    )
	  )
	  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  ;;; Hashbang.sh
	  (if (string= system-name "da1.hashbang.sh")
	  (progn
	    (print "Hashbang system.")
            ;;; This doesn't work with cloud drive, so swap the variable.
	    (setq clouddir-packages-available 'nil)
	    (add-to-list 'load-path "~/emacs.d")
	    ))

	  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  ;;; Tilde.Town
	  (if (string= system-name "tilde.town")
	  (progn
	    (print "Tilde.Town system.")
            ;;; This doesn't work with cloud drive, so swap the variable.
	    (setq clouddir-packages-available 'nil)
	    (add-to-list 'load-path "~/emacs.d")
	    ))

	  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  ;;; grex.org
	  (if (string= system-name "grex.org")
	  (progn
	    (print "grex.org system.")
            ;;; This doesn't work with cloud drive, so swap the variable.
	    (setq clouddir-packages-available 'nil)
	    (add-to-list 'load-path "~/emacs.d")
	    ))

     )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setting Various Environment Variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; I don't want backup files.
(setq make-backup-files nil)

;;;Upcase Region FTW
(put 'upcase-region 'disabled nil)

;;;Downcase Region FTW
(put 'downcase-region 'disabled nil)

;;;Stop the startup screen. This was set in a local .emacs, but I REALLY 
;;;don't want to see it. Like, ever.
(setq inhibit-startup-screen t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Loading general Modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; This space would be for ones that come with EMACS by default.

;;; These are modes that I install myself. Need to test to see if the
;;; specific machine supports them.
(if clouddir-packages-available
    (progn
      (message "Cloud Directory Packages are available.")

;;;Set Up Multi-Term
      (require 'multi-term)
      (setq multi-term-program shellprog)

;;;Set Up Neotree
      (setq neotreedir (concat cloud-dir "/neotree"))
      (add-to-list 'load-path neotreedir)
      (require 'neotree)
      (global-set-key [f8] 'neotree-toggle)

;;;Set Up Simplenote2
      (require 'simplenote2)
      (setq simplenote2-email "charles@mrguilt.com")
      (setq simplenote2-password nil)
      (simplenote2-setup)

;;;Set Up Atomic Chrome
      (require 'atomic-chrome)
      (atomic-chrome-start-server)
      
      ;;; End True
      )
  ;;; else
  (progn
      (message "Cloud Directory Packages are NOT available.")
;;; end else
      )
)

;;;Markdown Mode!
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(autoload 'gfm-mode "markdown-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; File Extensions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Auto Longline Mode for .txt and .html (blogstuff)
;;; 2016-12-09 Updated to use modern "visual-line-mode" instead of
;;;            "longlines-mode"
(setq auto-mode-alist (cons '("\.txt" . visual-line-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\.html" . visual-line-mode) auto-mode-alist))

;;;Longline mode for files in the form "snd.", as happens in mail out of
;;;elm (SDF). Also, "mutt..." for the mutt client.
(setq auto-mode-alist (cons '("snd\.*" . visual-line-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("mutt*" . visual-line-mode) auto-mode-alist))

;;;Number some lines! This seems to prevent going into the mode for the
;programming language. Putting a pin in that. 
;(setq auto-mode-alist (cons '("\.pl" . linum-mode) auto-mode-alist))
;(setq auto-mode-alist (cons '("\.html" . linum-mode) auto-mode-alist))
;(setq auto-mode-alist (cons '("\.el" lisp-mode linum-mode) auto-mode-alist))
;(setq auto-mode-alist (cons '("\.sh" . linum-mode) auto-mode-alist))

;;; Markdown Mode
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END OF CODE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;				NOTES
;;;QUESTION: Should I simply put machine-specific stuff, like typefaces
;;;          in a local .emacs, or have it as an if-then in this file?
;;;ANSWER: Yes--if I have to reblast a hard drive, all the settings are in
;;;        the cloud. All I need to recreate on the workstation is the 
;;;        .emacs that points it to this file.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			      CHANGE LOG
;;;
;;;2014-06-27: Updated for new WorkTop.
;;;2015-01-15: Work-Around for OS X 10.10 hostname bug
;;;2015-05-11: Updated for refreshed hard drive in WorkTop. 
;;;2016-12-09: Updated to use modern "visual-line-mode" instead of
;;;            "longlines-mode"
;;;2017-01-20: Added section for the Raspberry Pi
;;;            Turned off the menu for terminal mode. 
;;;2017-06-17: Added bic. Meh. Removed
;;;            (Catching up--needed to add kingswood to this. And
;;;            ip-172-31-128-206.ec2.internal (AKA spectr), my AWS
;;;            machine)
;;;2017-07-24: Minor re-arranging. Added system information block.
;;;2017-07-27: 1. Enabled this file to be used if a cloud drive is not
;;;               *typically* available on this system (i.e. the system
;;;               simply can't use Box (or whatever cloud drive provider
;;;               hosting my stuff) not that it simply isn't currently
;;;               connected)--it will bypass anything that would be 
;;;               depdent on that drive. 
;;;            2. In conjunction with the above, added the SDF system. It
;;;               required documenting all hosts names. File will be
;;;               periodically uploaded to that site.
;;;            3. Created "sign-it" command, to insert a signature file
;;;               at the bottom of the file.
;;;2017-08-02: Added section for Hashbang emacs.
;;;2017-10-18: 1. Removed caracal stuff
;;;            2. Added line numbering mode for perl and html files.
;;;               (need to learn a better way to do it in code).
;;;            3. Markdown Mode
;;;2017-10-24: Automatically enter visual-line-mode for elm and mutt (need
;;;            to put it on SDF)
;;;2017-10-25: Added Tilde.Town
;;;2017-12-24: Added grex.org and wintermute (well, wintermute was added
;;;            a while ago, but I neglected to notte it here. 
;;;2018-01-08: Added wraith.
;;;2018-01-25: Set up Neotree. 
;;;2018-01-30: Set up Simplenote2
;;;2018-01-31: Set up Atomic Chrome

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			     HOLDING ZONE
;;;
;;;This is for bits of code, modules, etc., I tried, didn't work out
;;;for one reason or another, so I am commenting them out. Keeping it,
;;;as I might be interested in it for some reason or another.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;BIC "Best IMAP Client." Not so much.
;;;https://github.com/legoscia/bic
;;;
;;;(add-to-list 'load-path (concat cloud-dir "/bic-master"))
;;;(require 'bic)
