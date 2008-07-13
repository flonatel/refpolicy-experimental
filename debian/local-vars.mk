############################ -*- Mode: Makefile -*- ###########################
## local-vars.mk --- 
## Author           : Manoj Srivastava ( srivasta@glaurung.green-gryphon.com ) 
## Created On       : Sat Nov 15 10:43:00 2003
## Created On Node  : glaurung.green-gryphon.com
## Last Modified By : Manoj Srivastava
## Last Modified On : Sun Aug 20 21:57:04 2006
## Last Machine Used: glaurung.internal.golden-gryphon.com
## Update Count     : 14
## Status           : Unknown, Use with caution!
## HISTORY          : 
## Description      : 
## 
## arch-tag: 1a76a87e-7af5-424a-a30d-61660c8f243e
## 
###############################################################################

FILES_TO_CLEAN  = debian/files
STAMPS_TO_CLEAN = 
DIRS_TO_CLEAN   = config/appconfig-strict-mcs config/appconfig-targeted-mcs 

# Location of the source dir
SRCTOP    := $(shell if [ "$$PWD" != "" ]; then echo $$PWD; else pwd; fi)
TMPTOP     = $(SRCTOP)/debian/$(package)
LINTIANDIR = $(TMPTOP)/usr/share/lintian/overrides
DOCBASEDIR = $(TMPTOP)/usr/share/doc-base

BINDIR  = $(TMPTOP)$(PREFIX)/bin
LIBDIR  = $(TMPTOP)$(PREFIX)/lib
# Man Pages
MANDIR    = $(TMPTOP)/usr/share/man
MAN1DIR   = $(MANDIR)/man1
MAN3DIR   = $(MANDIR)/man3
MAN5DIR   = $(MANDIR)/man5
MAN7DIR   = $(MANDIR)/man7
MAN8DIR   = $(MANDIR)/man8

INFODIR = $(TMPTOP)/usr/share/info
DOCTOP  = $(TMPTOP)/usr/share/doc
DOCDIR  = $(DOCTOP)/$(package)
MENUDIR   = $(TMPTOP)/usr/lib/menu/

OPTIONS=DISTRO=debian DIRECT_INITRC=y MONOLITHIC=n

PYDEFAULT  =$(strip $(shell pyversions -vd))
MODULES_DIR=$(TMPTOP)/usr/share/python-support/$(package)

# set this to -mcs, -mls, or -mcs-mls
MCS_MLS_TYPE=-mcs

# Things we have put into the base for Debian systems.
# egrep base debian/modules.conf.targeted | grep -v '#' | \
#     sort | sed -e 's/=.*$//g'
NON_MODULES=application apt authlogin clock corecommands \
            corenetwork  cron devices dmesg domain dpkg files filesystem \
            fstools getty hostname init iptables kernel libraries \
            locallogin logging logrotate mcs miscfiles mls modutils mount \
            mta selinux selinuxutil storage su sysnetwork terminal  \
            userdomain userhelper usermanage

define checkdir
	@test -f debian/rules -a -f policy/modules/kernel/kernel.fc || \
          (echo Not in correct source directory; exit 1)
endef

define checkroot
	@test $$(id -u) = 0 || (echo need root priviledges; exit 1)
endef
