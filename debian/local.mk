############################ -*- Mode: Makefile -*- ###########################
## local.mk --- 
## Author           : Manoj Srivastava ( srivasta@glaurung.green-gryphon.com ) 
## Created On       : Sat Nov 15 10:42:10 2003
## Created On Node  : glaurung.green-gryphon.com
## Last Modified By : Manoj Srivastava
## Last Modified On : Fri Dec 22 10:43:28 2006
## Last Machine Used: glaurung.internal.golden-gryphon.com
## Update Count     : 99
## Status           : Unknown, Use with caution!
## HISTORY          : 
## Description      : 
## 
## arch-tag: b07b1015-30ba-4b46-915f-78c776a808f4
## 
###############################################################################

MCS_MLS_TYPE=-mcs

testdir:
	$(testdir)

BUILD/selinux-policy-refpolicy-strict::    build/selinux-policy-refpolicy-strict
INST/selinux-policy-refpolicy-strict::     install/selinux-policy-refpolicy-strict
BIN/selinux-policy-refpolicy-strict::      binary/selinux-policy-refpolicy-strict


BUILD/selinux-policy-refpolicy-targeted::   build/selinux-policy-refpolicy-targeted
INST/selinux-policy-refpolicy-targeted::    install/selinux-policy-refpolicy-targeted
BIN/selinux-policy-refpolicy-targeted::     binary/selinux-policy-refpolicy-targeted


BUILD/selinux-policy-refpolicy-src::    build/selinux-policy-refpolicy-src
INST/selinux-policy-refpolicy-src::     install/selinux-policy-refpolicy-src
BIN/selinux-policy-refpolicy-src::      binary/selinux-policy-refpolicy-src


BUILD/selinux-policy-refpolicy-doc::    build/selinux-policy-refpolicy-doc
INST/selinux-policy-refpolicy-doc::     install/selinux-policy-refpolicy-doc
BIN/selinux-policy-refpolicy-doc::      binary/selinux-policy-refpolicy-doc

CLEAN/selinux-policy-refpolicy-strict CLEAN/selinux-policy-refpolicy-targeted CLEAN/selinux-policy-refpolicy-src CLEAN/selinux-policy-refpolicy-src::
	$(REASON)
	make bare
	test ! -d $(TMPTOP) || rm -rf $(TMPTOP)
	test ! -d $(SRCTOP)/debian/build-$(package) || \
                                      rm -rf $(SRCTOP)/debian/build-$(package)

CONFIG/selinux-policy-refpolicy-strict::
	$(REASON)
	test -e debian/stamp/config-strict  ||                             \
	  test ! -d $(SRCTOP)/debian/build-$(package) ||                   \
            rm -rf $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp/config-strict  ||                             \
	  mkdir -p    $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp/config-strict  ||                             \
	  cp -lr policy support Makefile build.conf Rules.modular  doc     \
               Rules.monolithic config VERSION Changelog COPYING INSTALL   \
                README man $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp/config-strict  ||                             \
	  $(MAKE) -C $(SRCTOP)/debian/build-$(package)                     \
                   NAME=refpolicy-strict TYPE=strict$(MCS_MLS_TYPE) $(OPTIONS) bare
	test -e debian/stamp/config-strict  ||                             \
	  (cd $(SRCTOP)/debian/build-$(package) ;                          \
           $(MAKE) NAME=refpolicy-strict TYPE=strict$(MCS_MLS_TYPE) $(OPTIONS) conf)
	cp debian/modules.conf.strict                                      \
                     $(SRCTOP)/debian/build-$(package)/policy/modules.conf
	echo done > debian/stamp/config-strict
STAMPS_TO_CLEAN += debian/stamp/config-strict
DIRS_TO_CLEAN  += debian/build-selinux-policy-refpolicy-strict

CONFIG/selinux-policy-refpolicy-targeted::
	$(REASON)
	test -e debian/stamp/config-targeted  ||                           \
	  test ! -d $(SRCTOP)/debian/build-$(package) ||                   \
            rm -rf $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp/config-targeted  ||                           \
	  mkdir -p    $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp/config-targeted  ||                           \
	  cp -lr policy support Makefile build.conf Rules.modular  doc     \
               Rules.monolithic config VERSION Changelog COPYING INSTALL   \
                README man $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp/config-targeted  ||                           \
	  $(MAKE) -C $(SRCTOP)/debian/build-$(package)                     \
                 NAME=refpolicy-targeted TYPE=targeted$(MCS_MLS_TYPE) $(OPTIONS) bare
	test -e debian/stamp/config-targeted  ||                           \
	  (cd $(SRCTOP)/debian/build-$(package) ;                          \
           $(MAKE) NAME=refpolicy-targeted TYPE=targeted$(MCS_MLS_TYPE) $(OPTIONS) conf)
	cp debian/modules.conf.targeted                                    \
                     $(SRCTOP)/debian/build-$(package)/policy/modules.conf
	echo done > debian/stamp/config-targeted
STAMPS_TO_CLEAN += debian/stamp/config-targeted
DIRS_TO_CLEAN  += debian/build-selinux-policy-refpolicy-targeted

CONFIG/selinux-policy-refpolicy-src::
	$(REASON)
	test -e debian/stamp/config-src         ||                        \
	  test ! -d $(SRCTOP)/debian/build-$(package) ||                  \
            rm -rf $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp/config-src         ||                        \
	  mkdir -p    $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp/config-src         ||                        \
	  cp -lr policy support Makefile build.conf Rules.modular  doc    \
               Rules.monolithic config VERSION Changelog COPYING INSTALL  \
                README man $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp/config-src         ||                        \
	  (cd $(SRCTOP)/debian/build-$(package) ;                         \
           $(MAKE) NAME=refpolicy $(OPTIONS) conf)
	cp debian/modules.conf.* $(SRCTOP)/debian/build-$(package)/policy/
	cp debian/build.conf     $(SRCTOP)/debian/build-$(package)/policy/
	echo done > debian/stamp/config-src
STAMPS_TO_CLEAN += debian/stamp/config-src
DIRS_TO_CLEAN  += debian/build-selinux-policy-refpolicy-src

CONFIG/selinux-policy-refpolicy-doc::
	$(REASON)
	test -e debian/stamp/config-doc         ||                         \
	  test ! -d $(SRCTOP)/debian/build-$(package) ||                   \
            rm -rf $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp/config-doc         ||                         \
	  mkdir -p    $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp/config-doc         ||                         \
	  cp -lr policy support Makefile build.conf Rules.modular  doc     \
               Rules.monolithic config VERSION Changelog COPYING INSTALL   \
                README man $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp/config-doc         ||                         \
	  (cd $(SRCTOP)/debian/build-$(package) ;                          \
           $(MAKE) NAME=refpolicy $(OPTIONS) conf )
	echo done > debian/stamp/config-doc
STAMPS_TO_CLEAN += debian/stamp/config-doc
DIRS_TO_CLEAN  += debian/build-selinux-policy-refpolicy-doc

BUILD-common::
	perl -wc debian/postinst.policy

build/selinux-policy-refpolicy-strict:
	$(REASON)
	test -e debian/stamp/build-strict                    ||            \
	  (cd $(SRCTOP)/debian/build-$(package) ;                          \
           $(MAKE) NAME=refpolicy-strict TYPE=strict$(MCS_MLS_TYPE) $(OPTIONS) policy all)
	echo done > debian/stamp/build-strict   
STAMPS_TO_CLEAN += debian/stamp/build-strict   

build/selinux-policy-refpolicy-targeted:
	$(REASON)
	test -e debian/stamp/build-targeted                    ||            \
	  (cd $(SRCTOP)/debian/build-$(package) ;                            \
           $(MAKE) NAME=refpolicy-targeted TYPE=targeted$(MCS_MLS_TYPE) $(OPTIONS) policy all)
	echo done > debian/stamp/build-targeted 
STAMPS_TO_CLEAN += debian/stamp/build-targeted   

build/selinux-policy-refpolicy-src:
	$(REASON)


build/selinux-policy-refpolicy-doc:
	$(REASON)


install/selinux-policy-refpolicy-strict:
	$(REASON)
	rm -rf               $(TMPTOP) $(TMPTOP).deb
	$(make_directory)    $(DOCDIR)/
	$(make_directory)    $(TMPTOP)/etc/selinux/refpolicy-strict/modules/active
	$(make_directory)    $(TMPTOP)/etc/selinux/refpolicy-strict/policy
	$(make_directory)    $(TMPTOP)/usr/share/selinux/
	test -f $(TMPTOP)/etc/selinux/refpolicy-strict/modules/active/file_contexts.local || \
	touch $(TMPTOP)/etc/selinux/refpolicy-strict/modules/active/file_contexts.local
	(cd $(SRCTOP)/debian/build-$(package);                      \
            $(MAKE) NAME=refpolicy-strict TYPE=strict$(MCS_MLS_TYPE) $(OPTIONS)\
                    DESTDIR=$(TMPTOP) install                       \
          $(TMPTOP)/etc/selinux/refpolicy-strict/users/local.users \
          $(TMPTOP)/etc/selinux/refpolicy-strict/users/system.users)
	$(install_file)      debian/setrans.conf  $(TMPTOP)/etc/selinux/refpolicy-strict/
	$(install_file)      VERSION              $(DOCDIR)/
	$(install_file)      README               $(DOCDIR)/
	$(install_file)      debian/README.Debian $(DOCDIR)/
	$(install_file)      debian/NEWS.Debian   $(DOCDIR)/NEWS.Debian 
	$(install_file)      Changelog            $(DOCDIR)/changelog
	$(install_file)      debian/changelog     $(DOCDIR)/changelog.Debian
	gzip -9fqr           $(DOCDIR)
	$(install_file)      debian/copyright     $(DOCDIR)/
DIRS_TO_CLEAN  += debian/selinux-policy-refpolicy-strict

install/selinux-policy-refpolicy-targeted:
	$(REASON)
	rm -rf               $(TMPTOP) $(TMPTOP).deb
	$(make_directory)    $(DOCDIR)/
	$(make_directory)    $(TMPTOP)/etc/selinux/refpolicy-targeted/modules/active
	$(make_directory)    $(TMPTOP)/etc/selinux/refpolicy-targeted/policy
	$(make_directory)    $(TMPTOP)/usr/share/selinux/
	test -f $(TMPTOP)/etc/selinux/refpolicy-targeted/modules/active/file_contexts.local || \
	touch $(TMPTOP)/etc/selinux/refpolicy-targeted/modules/active/file_contexts.local
	(cd $(SRCTOP)/debian/build-$(package);                      \
            $(MAKE) NAME=refpolicy-targeted TYPE=targeted$(MCS_MLS_TYPE) $(OPTIONS)\
                    DESTDIR=$(TMPTOP) install                       \
          $(TMPTOP)/etc/selinux/refpolicy-targeted/users/local.users \
          $(TMPTOP)/etc/selinux/refpolicy-targeted/users/system.users)
	$(install_file)      debian/setrans.conf  $(TMPTOP)/etc/selinux/refpolicy-targeted/
	$(install_file)      VERSION              $(DOCDIR)/
	$(install_file)      README               $(DOCDIR)/
	$(install_file)      debian/README.Debian $(DOCDIR)/
	$(install_file)      Changelog            $(DOCDIR)/changelog
	$(install_file)      debian/changelog     $(DOCDIR)/changelog.Debian
	gzip -9fqr           $(DOCDIR)
	$(install_file)      debian/copyright     $(DOCDIR)/
DIRS_TO_CLEAN  += debian/selinux-policy-refpolicy-targeted

install/selinux-policy-refpolicy-src:
	$(REASON)
	rm -rf               $(TMPTOP) $(TMPTOP).deb
	$(make_directory)    $(DOCDIR)/examples
	$(make_directory)    $(TMPTOP)/usr/src
	(cd $(SRCTOP)/debian/build-$(package);                                 \
         $(MAKE) NAME=refpolicy $(OPTIONS) DESTDIR=$(TMPTOP) bare conf install-src; )
	find $(TMPTOP) -type d -name .arch-ids -print0 | xargs -0r rm -rf
	test ! -e $(TMPTOP)/etc/selinux/refpolicy/src/policy/COPYING || \
           rm -f $(TMPTOP)/etc/selinux/refpolicy/src/policy/COPYING
	rm -rf   $(TMPTOP)/etc/selinux/refpolicy/src/policy/man
	(cd $(TMPTOP)/etc/selinux/refpolicy/src/policy;                   \
          if test -f modules.conf; then                                   \
              mv modules.conf modules.conf.dist;                          \
          fi;                                                             \
          ln -sf modules.conf.strict modules.conf)
	$(install_file)      policy/rolemap                               \
			     $(TMPTOP)/etc/selinux/refpolicy/src/policy/
	$(install_file)      debian/build.conf                            \
			     $(TMPTOP)/etc/selinux/refpolicy/src/policy/
	$(install_file)      debian/global_booleans.xml                   \
			     $(TMPTOP)/etc/selinux/refpolicy/src/policy/
	$(install_file)      debian/global_tunables.xml                   \
			     $(TMPTOP)/etc/selinux/refpolicy/src/policy/
	$(install_file)      debian/Makefile.src                          \
                             $(TMPTOP)/etc/selinux/refpolicy/src/policy/
	(cd $(TMPTOP)/etc/selinux/refpolicy/src/; mv policy $(package);   \
                                                  mv support $(package)/; \
	  tar zfc $(TMPTOP)/usr/src/$(package).tar.gz $(package))
	rm -rf               $(TMPTOP)/etc
	$(install_file)      VERSION              $(DOCDIR)/
	$(install_file)      README               $(DOCDIR)/
	$(install_file)      debian/README.Debian $(DOCDIR)/
	$(install_file)      Changelog            $(DOCDIR)/changelog
	$(install_file)      debian/changelog     $(DOCDIR)/changelog.Debian
	gzip -9fqr           $(DOCDIR)
	$(install_file)      debian/copyright     $(DOCDIR)/
	$(install_file)      debian/example.fc    $(DOCDIR)/examples/
	$(install_file)      debian/example.if    $(DOCDIR)/examples/
	$(install_file)      debian/example.te    $(DOCDIR)/examples/
	$(install_file)      debian/example.mk    $(DOCDIR)/examples/Makefile
	$(install_program)   debian/policygentool $(DOCDIR)/examples/
DIRS_TO_CLEAN  += debian/selinux-policy-refpolicy-src

install/selinux-policy-refpolicy-doc:
	$(REASON)
	rm -rf               $(TMPTOP) $(TMPTOP).deb
	$(make_directory)    $(DOCDIR)
	$(make_directory)    $(DOCBASEDIR)
	$(make_directory)    $(MAN8DIR)
	cp -a man/man8/*.8   $(MAN8DIR)
	$(install_file)      VERSION              $(DOCDIR)/
	$(install_file)      README               $(DOCDIR)/
	$(install_file)      debian/README.Debian $(DOCDIR)/
	$(install_file)      Changelog            $(DOCDIR)/changelog
	$(install_file)      debian/changelog     $(DOCDIR)/changelog.Debian
	$(install_file)      debian/docentry      $(DOCBASEDIR)/$(package)
	gzip -9fqr           $(MANDIR)
	gzip -9fqr           $(DOCDIR)
	(cd $(SRCTOP)/debian/build-$(package);                                   \
         $(MAKE) NAME=refpolicy $(OPTIONS) DESTDIR=$(TMPTOP)                     \
                 PKGNAME=selinux-policy-refpolicy-doc conf html install-docs;)
	gzip -9fq $(DOCDIR)/example.if $(DOCDIR)/example.fc $(DOCDIR)/Makefile.example 
	$(install_file)      debian/copyright     $(DOCDIR)/
	$(install_file)      debian/docentry         $(DOCBASEDIR)/$(package)
DIRS_TO_CLEAN  += debian/selinux-policy-refpolicy-doc

binary/selinux-policy-refpolicy-strict:
	$(REASON)
	$(checkdir)
	$(make_directory)    $(TMPTOP)/DEBIAN
	(cd $(TMPTOP); find etc -type f | sed 's,^,/,' > DEBIAN/conffiles)
	sed -e 's/=T/strict/g' debian/postinst.policy  > $(TMPTOP)/DEBIAN/postinst
	chmod 755                                      $(TMPTOP)/DEBIAN/postinst
	$(install_program)   debian/strict.postrm      $(TMPTOP)/DEBIAN/postrm
	dpkg-gencontrol    -V'debconf-depends=debconf (>= $(MINDEBCONFVER))' \
                              -p$(package) -isp   -P$(TMPTOP)
	$(create_md5sum)     $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..

binary/selinux-policy-refpolicy-targeted:
	$(REASON)
	$(checkdir)
	$(make_directory)    $(TMPTOP)/DEBIAN
	(cd $(TMPTOP); find etc -type f | sed 's,^,/,'  > DEBIAN/conffiles)
	sed -e 's/=T/targeted/g' debian/postinst.policy >$(TMPTOP)/DEBIAN/postinst
	chmod 755                                       $(TMPTOP)/DEBIAN/postinst
	$(install_program)   debian/targeted.postrm     $(TMPTOP)/DEBIAN/postrm
	dpkg-gencontrol    -V'debconf-depends=debconf (>= $(MINDEBCONFVER))' \
                              -p$(package) -isp   -P$(TMPTOP)
	$(create_md5sum)   $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..

binary/selinux-policy-refpolicy-src:
	$(REASON)
	$(checkdir)
	$(make_directory)    $(TMPTOP)/DEBIAN
	dpkg-gencontrol    -V'debconf-depends=debconf (>= $(MINDEBCONFVER))' \
                              -p$(package) -isp   -P$(TMPTOP)
	$(create_md5sum)   $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..

binary/selinux-policy-refpolicy-doc:
	$(REASON)
	$(checkdir)
	$(make_directory)    $(TMPTOP)/DEBIAN
	(cd $(TMPTOP); find etc -type f | sed 's,^,/,' > DEBIAN/conffiles)
	$(install_program)   debian/doc.postinst      $(TMPTOP)/DEBIAN/postinst
	$(install_program)   debian/doc.prerm         $(TMPTOP)/DEBIAN/prerm
	dpkg-gencontrol    -V'debconf-depends=debconf (>= $(MINDEBCONFVER))' \
                              -p$(package) -isp   -P$(TMPTOP)
	$(create_md5sum)   $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..


