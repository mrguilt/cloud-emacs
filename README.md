# cloud-emacs
Common dot emacs in the cloud, to float among my systems

The basic idea is that, when using multiple systems, to have as many
of my EMACS settings and packages maintained across systesm. This is
accomplished via some form of a shared drive, such as a cloud storage
provider. A directory in the cloud holds all the varous EMACS
packages, along with a master .emacs file, called dot.emacs.el.

When emacs is lauched, .emacs sets a variable, called cloud-dir, adds
it to the load path, and dot.emacs.el takes over. it sets the common
variables and loads packages.

Within dot.emacs.el, a series of tests is performed based on system
type (GUI versus terminal) and the system name, and some specific
settings are set. Technically, this could be done in the local .emacs
file (I mean, that's why it's there after all), it serves three
purposes:

1. Should the system need to be wiped and rebuilt, only the cloud
   hand-off needs to be set up.
2. A new system can be added to the mix and recieve the same (or
   tweaked) version of the settings used by another system.
3. Some of the items tested for set up later calls. Again, this could
   be done in the local .emacs, but incorporating it in one master
   makes it one place to adjust.

It is actually pretty cool to set up a new package at home on my
personal system, and it's already there when I get to work the next
day.

The files are currently assuming the common space is stored in a
directory called "elisp" on cloud storage provided by Box
(http://www.box.com). Since it really is just directory paths, it
could hypothetically be any cloud storage provider, or some other
shared network drive.

Files in this package
dot.emacs.el			This is the common file
general-workstation.emacs	The local .emacs file
mobile-workstations.emacs 	A .emacs that will use either local
				or shared elisp directory.

MOBILE WORKSTATION VARIANT

This version assumes the cloud directory is periodically replicated
locally (a lot of cloud software works this way by default). The
assumption is that the shared version is the preferred version (it
should be near-instantly up-to-date), but will use the local,
potentially dated version if that is not available.

Replciation of the cloud directory is handled outside of this system.

ISLAND SYSTEMS

There are some systems I use that are "islands:" I can log into them,
and even copy files to them, however, they do not have any access to
cloud storage. Due to some practical limitations (disk quotas,
bandwidth to replicate the directory, etc.), putting all the cloud
packages is not practical. However, I still want to have the other
settings used for EMACS.

A varialbe clouddir-packages-available is set to true on lauch. If the
cloud storage is not available, the variable is set to nil. The hooks
for the cloud packages are in a test of that variable. This notion
could likely be expanded to specific packages (ones that are on some
systems but not others).
