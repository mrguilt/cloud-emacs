;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Shared dot-emacs
;;;
;;; This is the .emacs file that will be shared among all systems. 
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			      REFERENCE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;	     Elisp system-name Output for Active Systems
;;;
;;; Personal/Local Systems
;;; -------------- -------
;;; New MacBook Pro="kingswood"
;;; Raspberry Pi Zero="squip"
;;; Virtual Windows System="TARS"
;;;
;;; Remote Systems
;;; ------ -------
;;; Google Cloud Server ("spectr" in DNS)="instance-4"
;;; SDF Free UNIX="sdf", "faeroes", "iceland", "miku", "otaku", "rie", 
;;;               "sverige" and "norge" (round robin assignment at login
;;;               to tty.sdf.org)
;;; SDF MetaAaray="ma.sdf.org"
;;; hashbang="da1.hashbang.sh"
;;; Tilde.Town="tilde.town"
;;; grex.org="grex.org"
;;; Republic="republic.circumlunar.space"
;;;
;;; Cloud Directory is currently on Box.com. (2017-07-27)
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
(print user-real-login-name)
(print "dot.emacs.el file last updated 2020-05-05.")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Test if cloud directories are avaialble.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar clouddir-packages-available t
  "Works with my model of storing elisp, et al., in the cloud. Tests in scripts (such as dot.emacs) can incldue or exclude based on that. Default is true.")

;;;Are there cloud directories? The check is for nil, or for ~.
(if (not (boundp `cloud-dir))
    (setq clouddir-packages-available 'nil)
  (progn
    (if (string= cloud-dir "~")
	(setq clouddir-packages-available 'nil)
      )
    ))

;;;I also don't want cloud directories loaded for root.
 (if (string= user-real-login-name "root")
     (setq clouddir-packages-available 'nil)
   )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Loading General Modes, Part 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This space would be for ones that come with EMACS by default.
;;; These would be if the cloud directory is available.
  
;;; These are modes that I install myself. Need to test to see if the
;;; specific machine supports them.
(if clouddir-packages-available
    (progn
      (message "Cloud Directory Packages are available.")
      
;;;My personal functions
      (load-library "icb-functions")
      ;;; End True

;;;Load basic-mode and configure
      (autoload 'basic-mode "basic-mode" "Major mode for editing BASIC code." t)
      (add-to-list 'auto-mode-alist '("\\.bas\\'" . basic-mode))
      (setq basic-auto-number 10)
      (setq basic-line-number-cols 1)
      
;;;Set Up Simplenote2
     (require 'simplenote2)
     (setq simplenote2-email nil)
     (setq simplenote2-password nil)
     (setq simplenote2-markdown-notes-mode `markdown-mode)
     (simplenote2-setup)

     ;;;Default: Markdown on. C-u M-x simplenote2-set-markdown to turn off. I may set tags as well. 
     (add-hook 'simplenote2-create-note-hook
	  (lambda ()
	    (simplenote2-set-markdown)
;;;	    (simplenote2-add-tag "tag1")
	    ))
    ;;;Nyan Mode, for the LOLs.
    (load-library "nyan-mode")
     
;;;There are some packages that only make sense in a GUI, especially if
;;;I'm connecting in via an SSH type session. So, I'm only going to run them
;;;GUI mode.
;;;
;;;I recognize there is a GUI test when assigning machine-stuff. However,
;;;those actions should apply regardless as to whether the cloud packages
;;;are available. 
      (if (display-graphic-p)
	  (progn
	    (print "GUI Cloud Packages Loading...")
;;;Set Up Atomic Chrome
	    (require 'atomic-chrome)
	    (atomic-chrome-start-server)
	    )
	)
      (load-library "minimap")
      )
  ;;; else
  (progn
      (message "Cloud Directory Packages are NOT available.")
;;; end else
      )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			    Default Values
;;; These are "default unless I say otherwise." So, if I fire up EMACS, it
;;; will use these values, unless it's reset in a machine-specific section.
;;; Spelling Stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Spelling Stuff
;;; Setting spellcheck to aspell, since it seems to be more commonly
;;; available in all cases. Hunspell will be put where appropriate.
;;;(setq ispell-program-name "hunspell")
(setq ispell-program-name "aspell")
(global-set-key (kbd "<f8>") 'flyspell-check-previous-highlighted-word)
;;; I don't want backup files.
(setq make-backup-files nil)

;;; Default autosave interval is 300 characters. Not bad for coding, but
;;; annoying for general typing. Setting it to 2500 characters.
(setq auto-save-interval 2500)

;;; Put the auto-save files in the temp directory. I was originally going
;;; to do this just for the WorkTop, but I like the idea of making it
;;; standard. 
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


;;;Upcase and Downcase Region FTW
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;;Stop the startup screen. This was set in a local .emacs, but I REALLY 
;;;don't want to see it. Like, ever.
(setq inhibit-startup-screen t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Platform-specific check. These can be overwritten per machine if need
;;; be (for instance, if bash isn't at /bin/bash).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (eq system-type 'windows-nt)
  (progn
    (print "Windows system")
;mulit-term doesn't seem to want to work in windows. still thinking about it.
    (setq shellprog "C:/windows/system32/cmd.exe")
    (add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/")
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
      
;;;The curl that ships with Windows is old, and doesn't work with SimpleNote2
;;;so I downloaded a more recent version, and put it in the location specified
;;;below (I'll add this to other Windows machines).

      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;;; Things for the Virtual Windows System
      (if (string= system-name "TARS")
	  (progn
	    (print "It's a Windows VM!")
	    (set-face-attribute 'default nil :font "Cousine")
	    (set-face-attribute 'default (selected-frame) :height 140) ;;;Make the typeface a bit bigger (120%).
	    (setq machine-font "Cousine")
	    (set-background-color "#ffca60")
      	    (setq ispell-program-name "hunspell")
	    (cd "~")
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
	    (setq machine-font "Liberation Mono")
	    (setq tempword "~/box/documents/temp-markdown.docx")
;;;	    (setq tempword-template "/home/chbarr/box/documents/pandoc-templates/template-2018-09-27.docx")
	    (setq tempword-template "~/box/documents/pandoc-templates/template-2018-09-27.docx")

	    ))

;;; Things for New Macbook
      (if (string= system-name "kingswood")

	  (progn
	    (print "It's Kingswood, the new Macbook Pro!")
	    (set-face-attribute 'default (selected-frame) :height 155) ;;;Make the typeface a bit bigger (155%).
	    (print "setting machine font")
;;;    	    (setq machine-font "IBM Plex Mono")
	    (setq machine-font "JetBrains Mono Medium")
	    (print "set")
	    (set-background-color "#fcf8e1")
      	    (setq ispell-program-name "/usr/local/bin/hunspell")
	    ;;;Apparently, OS X does not pick up the path from the shell. I'm hardcoding it as a work around--hopefully just temporarily.
	    (setenv "PATH" "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/chbarr/bin")

;;;Binding commands to keys, to, in turn, put in the TouchBar
	    ;;;Bind mdcopy to C-<f10>
	    (global-set-key (kbd "C-<f10>") 'mdcopy)
	    ;;;Bind tempword-buffer to C-S-<f10>
	    (global-set-key (kbd "C-S-<f10>") 'tempword-buffer)	    
	    ;;;Bind xkcd-copy to C-S-<f9>
	    (global-set-key (kbd "C-S-<f9>") 'xkcd-it)
	    ;;;Bind use-machine-font to M-C-S-<f9>
	    (global-set-key (kbd "M-C-S-<f9>") 'use-machine-font)
	    ))

;;; GUI stuff after machine stuff--probably based on items in the machine-specific sections
      (print "set machine font here")
      (set-face-attribute 'default nil :font machine-font)

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

 	  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  ;;; "squip"
	  (if (string= system-name "squip")
	  (progn
	    (print "Squip (Raspberry Pi Utility System), in the Terminal")
      	    (setq tempword "~/box/documents/temp-markdown.docx")
	    (setq tempword-template "/home/chbarr/box/documents/pandoc-templates/template-2018-09-27.docx") ;;;had to be absolute. who who knows?
	    ))

	  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  ;;; spectr
	  (if (string= system-name "instance-4")
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
	  (if (member system-name '("sdf" "faeroes" "iceland" "miku" "norge" "otaku" "rie" "sverige"))
	  (progn
	    (print "A SDF Free UNIX server")
            ;;; This doesn't work with cloud drive, so swap the variable.
	    (setq clouddir-packages-available 'nil)
	    (add-to-list 'load-path "~/emacs.d")
	    ;;;My personal functions--copied locally
	    (load-library "icb-functions")
	    ;;;Change key binding so backspace and DEL work as expected.
	    (global-set-key "\C-d" 'backward-delete-char-untabify)
	    (global-set-key [delete] 'delete-char)
	    )
	  )

	  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  ;;; SDF MetaArray Server
	  (if (string= system-name "ma.sdf.org")
	  (progn
	    (print "The SDF MetaArray server")
            ;;; This doesn't work with cloud drive, so swap the variable.
	    (setq clouddir-packages-available 'nil)
	    (add-to-list 'load-path "~/emacs.d")
	    ;;;My personal functions--copied locally
	    (load-library "icb-functions")
	    ;;;Change key binding so backspace and DEL work as expected.
	    (global-set-key "\C-d" 'backward-delete-char-untabify)
	    (global-set-key [delete] 'delete-char)
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
	  ;;; republic.circumlunar.space
	  (if (string= system-name "republic.circumlunar.space")
	  (progn
	    (print "Republic System")
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
;;; Special Stuff for root
;;;
;;; Basically, I wanted to have a distinct color, and I didn't want all the
;;; cloud packages (typically, I'm editing a config file, not doing crazy
;;; stuff). 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(if (string= user-real-login-name "root")
    (progn
      (print "root user!")
      (set-background-color "#FFCCF8")
      (setq clouddir-packages-available 'nil)
     )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Loading General Modes, Part 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;Start spellcheck in visual line mode.
(add-hook 'visual-line-mode-hook 'flyspell-mode)

;;;Markdown Mode!
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(autoload 'gfm-mode "markdown-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)
;;;When I start Markdown Mode, I want visual wrapping and spell check.
(add-hook 'markdown-mode-hook 'visual-line-mode)
(add-hook 'markdown-mode-hook 'flyspell-mode)

;;;When I start HTML Mode, I want visual wrapping and spell check.
(add-hook 'html-mode-hook 'visual-line-mode)
(add-hook 'html-mode-hook 'flyspell-mode)

;;;I can't think of when I wouldn't want visual line mode without spell check. 
(add-hook 'visual-line-mode-hook 'flyspell-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; File Extensions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Auto Longline Mode for .txt and .html (blogstuff)
;;; 2016-12-09 Updated to use modern "visual-line-mode" instead of
;;;            "longlines-mode"
(setq auto-mode-alist (cons '("\.txt" . visual-line-mode) auto-mode-alist))

;;;Longline mode for files in the form "snd.", as happens in mail out of
;;;elm (SDF). Also, "mutt..." for the mutt client.
(setq auto-mode-alist (cons '("snd\.*" . visual-line-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("mutt*" . visual-line-mode) auto-mode-alist))

;;; Markdown Mode
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

;;; HTML Mode
(add-to-list 'auto-mode-alist '("\\.html\\'" . html-mode))

;;; JaveScript Mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setting Up E-Mail
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Big Variables. I'm settig this up for my mail server.
(setq user-full-name "I. Charles Barilleaux")
(setq user-mail-address "Charles@MrGuilt.com")

;;;Puts visual-line-mode on when you start sending mail. 
(add-hook 'mail-mode-hook #'visual-line-mode)
(add-hook 'message-mode-hook #'visual-line-mode)

;;; Outbound Mail stuff
(setq smtpmail-default-smtp-server "spectr.mrguilt.com"
       smtpmail-local-domain "mrguilt.com")
(load-library "smtpmail")

(setq send-mail-function 'smtpmail-send-it)
(setq message-send-mail-function 'smtpmail-send-it)
(setq send-mail-function    'smtpmail-send-it
      smtpmail-smtp-server  "spectr.mrguilt.com"
      smtpmail-stream-type  'ssl
      smtpmail-smtp-service 465)

;;;Read Mail with GNUS
(setq gnus-select-method 
      '(nnimap "mrguilt.com"
	       (nnimap-address "spectr.mrguilt.com")
	       (nnimap-server-port 993)
	       (nnimap-stream ssl)
;;;              (nnimap-authinfo-file "~/.authinfo")
))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Documentation in Messages Buffer
;;;
;;; 'Cause I keep forgetting some mappings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(print "Stuff I set up but forget:\n")
(print "\tF8\tFlyspell Offer Suggestions")
(print "\tM-x epa-*\tEasy GPG Stuff")


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
;;;            a while ago, but I neglected to note it here. 
;;;2018-01-25: Set up Neotree. 
;;;2018-01-30: Set up Simplenote2
;;;2018-01-31: Set up Atomic Chrome
;;;2018-02-10: 1. Moved functions I wrote into icb-functions.el. Only 
;;;               catch is that the sigfile variable must be defined
;;;               here.
;;;            2. Set Atomic Chrome to default to visual-line-mode.
;;;            3. Removed spectr-temp (AWS)
;;;2018-03-12: 1. Set up spell checking!
;;;            2. Moved variables to the top. This will allow them to be
;;;               reset on a machine-by-machine basis if necessary.
;;;            3. Created case for Squip-in-terminal. How did I not already
;;;               have that?
;;;2018-03-13: 1. Set spell checking variable for grex, SDF, and tilde.town.
;;;               This has me questioning my defaults approach: should the
;;;               default be the preferred approach, or the exceptional
;;;               approach? 
;;;2018-03-14: 1. For the above: decided to go the route of setting default
;;;               to most common case (aspell), and setting the preferred
;;;               one (hunspell) where appropriate. This is more in keeping
;;;               with the philosopy of this shared .emacs.
;;;            2. Created case for Kingswood-in-terminal.
;;;2018-04-27: 1. Set it up so entering markdown-mode also starts
;;;               visual-line-mode and flyspell-mode.
;;;            2. Set it up so entering visual-line-mode also starts
;;;               flyspell-mode.
;;;2018-05-03: 1. Created a bit of documentation.
;;;            2. Changed background color for WorkTop.
;;;2018-07-22: 1. Reset the autosave interval to 2500 characters.
;;;            2. Changed Kingswood font to Roboto Mono. Kinda dig it. 
;;;2018-08-16: 1. Updated WorkTop to use Hunspell. Too easy--why didn't
;;;               I do it sooner?
;;;            2. Flipped some keys: F8 does Flyspell; C-F8 does Neotree
;;;               (though I may remove Neotree). 
;;;            3. Took out org-toodledo. I haven't used org-mode, so I
;;;               want to remove the overhead. 
;;;2018-08-18: 1. Set up outbound mail stuff (mrguilt.com)
;;;            2. Set up GNUS to read mail.
;;;            3. Added hooks to do visual line mode for mail windows.
;;;2018-08-20: 1. Added a test to only load packages that interact with the
;;;               GUI, like Atomic Chrome, when using a GUI version.
;;;            2. I have yet to use Multi-Term. So I removed it.
;;;2018-09-12: 1. Officially gave up on NeoTree. Nothing wrong with it;
;;;               I just wasn't using it. 
;;;2018-10-05: 1. Set it to put autosave files in the temp directory. 
;;;            2. Turned off lock files on the WorkTop. Didn't do it
;;;               globally, as I'm not 100% sure of the implications. I
;;;               think OneDrive doesn't like files that use the hash
;;;               character. 
;;;2018-10-23: 1. Modified key bindings for SDF so backspace and del work
;;;               as expected.
;;;2018-11-30: 1. Playing with fonts on the WorkTop
;;;2018-12-14: 1. Updated code for new Google Cloud instance
;;;2018-12-23: 1. Added a Windows VM I use at home, "TARS."
;;;2019-01-07: 1. Trying out CourierPrime on the WorkTop
;;;            2. Going to try a light-blue background there, too. 
;;;2019-01-10: 1. Added republic.circumlunar.space
;;;2019-04-11: 1. Set "tempword" variable for WordTop.
;;;2019-05-17: 1. New WorkTop. Who dis?
;;;            2. Removed the Mac Mini
;;;2019-08-22: 1. New WorkTop font (Plex Mono)
;;;2019-09-04: 1. Added hooks for HTML mode.
;;;            2. Set it so visual line mode always got spell checked.
;;;2019-09-05: 1. Created machine-font variable. Will eventually just have one
;;;               set-face-attribute for font.
;;;            2. Set WorkTop to use the machine-font variable rather than
;;;               setting in the if-then.
;;;            3. Set Kingswood to use the machine-font variable rather than
;;;               setting in the if-then.
;;;2019-09-06: 1. Better definition of tempword, with default
;;;            2. Set tempword variable for squip.
;;;            3. Got rid of SimpleNote. 
;;;2019-09-11: 1. Switching to the beta. This puts a test for cloud directories
;;;               at the front. The goal is to allow some modules to load prior
;;;               to machine tests. 
;;;2019-09-18: 1. Moved the variables used by icb-functions.el to the
;;;               icb-functions.el file. Now, the only time they are set here
;;;               is if they are different than the default. 
;;;2019-09-19: 1. New SDF host, rie
;;;2019-09-24: 1. Got the scoop on SimpleNote. Windows had an old version
;;;               of curl. Updated it, and, for the WorkTop, set the
;;;               request-curl variable.
;;;            2. Added the simplenote2 stuff back in. 
;;;2019-09-26: 1. Set Simplenote2 to default to Markdown for new notes. 
;;;2019-10-01: 1. Added the SDF MetaARPA and MetaArray servers.
;;;            2. Loading Nyan Mode, just 'cause.
;;;2019-10-17: 1. For whatever reason, after upgrading squip to the latest
;;;               OS version ("Buster"), hunspell doesn't work. Removed the
;;;               lines and use the "default" of aspell. 
;;;2019-11-02: 1. Added a test within the Kingswood section for the Windows
;;;               boot. I still want the Linux and Windows sides to be similar,
;;;               but there are a few must-dos in Windows.
;;;            2. Resized KINGSWOODW's typeface size.
;;;            3. Added pointer to KINGSWOODW's modern curl to make SimpeNote
;;;               work. 
;;;2019-11-09: 1. Removed the Accenture WorkTop
;;;            2. New Kingswood typeface.
;;;            3. New section for TBD-named MacBook Pro
;;;2019-11-16: 1. I had to hard-code the path for the new MacBook.
;;;            2. Mapped C-<F10> to mdcopy
;;;2019-11-23: 1. Removed the HP Omen
;;;            2. New MacBook has inhereted the "Kingswood" name. Huzah!
;;;2019-11-25: 1. Added some (obscure) key bindings to kingswood, to, in turn
;;;               map to touch bar keys. 
;;;2020-01-16: 1. Set a new font for kingswood
;;;2020-01-23: 1. Bound c-s-F10 to tempword-buffer for Kingswood (touch bar)
;;;2020-02-08: 1. Loading the Minimap Mode
;;;2020-05-05: 1. Set "js" to load javascript mode.
;;;            2. Loading BASIC mode. Set BAS to load the mode, and set a few
;;;               relavent variables.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;			     HOLDING ZONE
;;;
;;;This is for bits of code, modules, etc., I tried, didn't work out
;;;for one reason or another, so I am commenting them out. Keeping it,
;;;as I might be interested in it for some reason or another.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
					;
;;;Set Up Neotree
;;;This puts a tree file manager when you press a hot key. I never used it.
;;;      (setq neotreedir (concat cloud-dir "/neotree"))
;;;      (add-to-list 'load-path neotreedir)
;;;      (require 'neotree)
;;;      (global-set-key (kbd "C-<f8>") 'neotree-toggle)
;;;
;;;Documentation
;;;(print "\tC-F8\tNeoTree file browser")

;;;SimpleNote2 wasn't working on Windows. I had to download a version of Curl
;;;("modern" as described in the email I received in an email) that would
;;;work with it. As I removed my last windows box somewhere along the line, I
;;;wanted to capture this. Basically, download the new version, stick it some-
;;where, and point EMACS to it (request-curl).
;;;Modern curl URL: l.mrguilt.com/curl4win
;;;(setq request-curl "D:\\Windows Programs\\curl4win\\curl.exe")
