############################ -*- Mode: Makefile -*- ###########################
## local.mk --- 
## Author           : Manoj Srivastava ( srivasta@glaurung.green-gryphon.com ) 
## Created On       : Sat Nov 15 10:42:10 2003
## Created On Node  : glaurung.green-gryphon.com
## Last Modified By : Manoj Srivastava
## Last Modified On : Mon May  7 08:55:23 2007
## Last Machine Used: glaurung.internal.golden-gryphon.com
## Update Count     : 106
## Status           : Unknown, Use with caution!
## HISTORY          : 
## Description      : 
## 
## arch-tag: b07b1015-30ba-4b46-915f-78c776a808f4
## 
###############################################################################

testdir:
	$(testdir)
CONFIG-common:: stamp-conf/selinux-policy-src

BUILD/selinux-policy-mls::    build/selinux-policy-mls
INST/selinux-policy-mls::     install/selinux-policy-mls
BIN/selinux-policy-mls::      binary/selinux-policy-mls


BUILD/selinux-policy-default::   build/selinux-policy-default
INST/selinux-policy-default::    install/selinux-policy-default
BIN/selinux-policy-default::     binary/selinux-policy-default

BUILD/selinux-policy-dev::    build/selinux-policy-dev
INST/selinux-policy-dev::     install/selinux-policy-dev
BIN/selinux-policy-dev::      binary/selinux-policy-dev


BUILD/selinux-policy-src::    build/selinux-policy-src
INST/selinux-policy-src::     install/selinux-policy-src
BIN/selinux-policy-src::      binary/selinux-policy-src


BUILD/selinux-policy-doc::    build/selinux-policy-doc
INST/selinux-policy-doc::     install/selinux-policy-doc
BIN/selinux-policy-doc::      binary/selinux-policy-doc

CLEAN/selinux-policy-mls CLEAN/selinux-policy-default CLEAN/selinux-policy-src CLEAN/selinux-policy-src::
	$(REASON)
	make bare
	test ! -d $(TMPTOP) || rm -rf $(TMPTOP)
	test ! -d $(SRCTOP)/debian/build-$(package) || \
                                      rm -rf $(SRCTOP)/debian/build-$(package)

stamp-conf/selinux-policy-src:
	$(REASON)
	test -d $(SRCTOP)/config/appconfig-mcs  || \
            cp -a $(SRCTOP)/config/appconfig-mcs $(SRCTOP)/config/appconfig-default
	test -d $(SRCTOP)/config/appconfig-mcs  || \
            cp -a $(SRCTOP)/config/appconfig-mls $(SRCTOP)/config/appconfig-mls

CONFIG/selinux-policy-mls::
	$(REASON)
	test -e debian/stamp-config-mls  ||                             \
	  test ! -d $(SRCTOP)/debian/build-$(package) ||                   \
            rm -rf $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp-config-mls  ||                             \
	  mkdir -p    $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp-config-mls  ||                             \
	  cp -lr policy support Makefile Rules.modular  doc                \
               Rules.monolithic config VERSION Changelog COPYING INSTALL   \
                README man $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp-config-mls  ||                             \
	  cp debian/build.conf.mls $(SRCTOP)/debian/build-$(package)/build.conf
	test -e debian/stamp-config-mls  ||                             \
	  $(MAKE) -C $(SRCTOP)/debian/build-$(package)                     \
                   NAME=mls TYPE=mls $(OPTIONS) bare
	test -e debian/stamp-config-mls  ||                             \
	  cp debian/modules.conf.mls.update debian/build-$(package)/policy/modules.conf
	test -e debian/stamp-config-mls  ||                             \
	  (cd $(SRCTOP)/debian/build-$(package) ;                          \
           $(MAKE) NAME=mls TYPE=mls $(OPTIONS) conf)
	echo done > debian/stamp-config-mls
STAMPS_TO_CLEAN += debian/stamp-config-mls
DIRS_TO_CLEAN  += debian/build-selinux-policy-mls

CONFIG/selinux-policy-default::
	$(REASON)
	test -e debian/stamp-config-default  ||                           \
	  test ! -d $(SRCTOP)/debian/build-$(package) ||                   \
            rm -rf $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp-config-default  ||                           \
	  mkdir -p    $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp-config-default  ||                           \
	  cp -lr policy support Makefile  Rules.modular  doc               \
               Rules.monolithic config VERSION Changelog COPYING INSTALL   \
                README man $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp-config-default  ||                           \
	  cp debian/build.conf.default $(SRCTOP)/debian/build-$(package)/build.conf
	test -e debian/stamp-config-default  ||                           \
	  $(MAKE) -C $(SRCTOP)/debian/build-$(package)                     \
                 NAME=default TYPE=mcs $(OPTIONS) bare
	test -e debian/stamp-config-default  ||                           \
	  cp debian/modules.conf.default.update debian/build-$(package)/policy/modules.conf
	test -e debian/stamp-config-default  ||                           \
	  (cd $(SRCTOP)/debian/build-$(package) ;                          \
           $(MAKE) NAME=default TYPE=mcs $(OPTIONS) conf)
	echo done > debian/stamp-config-default
STAMPS_TO_CLEAN += debian/stamp-config-default
DIRS_TO_CLEAN  += debian/build-selinux-policy-default

CONFIG/selinux-policy-src::
	$(REASON)
	test -e debian/stamp-config-src         ||                        \
	  test ! -d $(SRCTOP)/debian/build-$(package) ||                  \
            rm -rf $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp-config-src         ||                        \
	  mkdir -p    $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp-config-src         ||                        \
	  cp -lr policy support Makefile Rules.modular  doc               \
               Rules.monolithic config VERSION Changelog COPYING INSTALL  \
                README man $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp-config-src         ||                        \
           cp  debian/build.conf.default $(SRCTOP)/debian/build-$(package)/build.conf
	test -e debian/stamp-config-src         ||                        \
	  (cd $(SRCTOP)/debian/build-$(package) ;                         \
           $(MAKE) NAME=default $(OPTIONS) conf)
	cp debian/modules.conf.*      $(SRCTOP)/debian/build-$(package)/policy/
	cp debian/build.conf.default $(SRCTOP)/debian/build-$(package)/policy/
	echo done > debian/stamp-config-src
STAMPS_TO_CLEAN += debian/stamp-config-src
DIRS_TO_CLEAN  += debian/build-selinux-policy-src

CONFIG/selinux-policy-dev::
	$(REASON)
	test -e debian/stamp-config-dev         ||                        \
	  test ! -d $(SRCTOP)/debian/build-$(package) ||                  \
            rm -rf $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp-config-dev         ||                        \
	  mkdir -p    $(SRCTOP)/debian/build-$(package)
	echo done > debian/stamp-config-dev
STAMPS_TO_CLEAN += debian/stamp-config-dev
DIRS_TO_CLEAN  += debian/build-selinux-policy-dev

CONFIG/selinux-policy-doc::
	$(REASON)
	test -e debian/stamp-config-doc         ||                         \
	  test ! -d $(SRCTOP)/debian/build-$(package) ||                   \
            rm -rf $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp-config-doc         ||                         \
	  mkdir -p    $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp-config-doc         ||                         \
	  cp -lr policy support Makefile Rules.modular  doc                \
               Rules.monolithic config VERSION Changelog COPYING INSTALL   \
                README man $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp-config-doc         ||                        \
           cp  debian/build.conf.default $(SRCTOP)/debian/build-$(package)/build.conf
	test -e debian/stamp-config-doc         ||                         \
	  (cd $(SRCTOP)/debian/build-$(package) ;                          \
           $(MAKE) NAME=default $(OPTIONS) conf )
	echo done > debian/stamp-config-doc
STAMPS_TO_CLEAN += debian/stamp-config-doc
DIRS_TO_CLEAN  += debian/build-selinux-policy-doc

BUILD-common::
	perl -wc debian/postinst.policy

build/selinux-policy-mls:
	$(REASON)
	test -e debian/stamp-build-mls                    ||            \
	  (cd $(SRCTOP)/debian/build-$(package) ;                          \
           $(MAKE) NAME=mls TYPE=mls $(OPTIONS) policy all)
	echo done > debian/stamp-build-mls   
STAMPS_TO_CLEAN += debian/stamp-build-mls   

build/selinux-policy-default:
	$(REASON)
	test -e debian/stamp-build-default                    ||            \
	  (cd $(SRCTOP)/debian/build-$(package) ;                            \
           $(MAKE) NAME=default TYPE=mcs $(OPTIONS) policy all)
	echo done > debian/stamp-build-default 
STAMPS_TO_CLEAN += debian/stamp-build-default   

build/selinux-policy-src:
	$(REASON)

build/selinux-policy-dev:
	$(REASON)

build/selinux-policy-doc:
	$(REASON)


install/selinux-policy-mls:
	$(REASON)
	rm -rf               $(TMPTOP) $(TMPTOP).deb
	$(make_directory)    $(DOCDIR)/
	$(make_directory)    $(TMPTOP)/etc/selinux/mls/modules/active
	$(make_directory)    $(TMPTOP)/etc/selinux/mls/policy
	test -f $(TMPTOP)/etc/selinux/mls/modules/active/file_contexts.local || \
	touch $(TMPTOP)/etc/selinux/mls/modules/active/file_contexts.local
	touch $(TMPTOP)/etc/selinux/mls/modules/semanage.read.LOCK
	chmod 600 $(TMPTOP)/etc/selinux/mls/modules/semanage.read.LOCK
	touch $(TMPTOP)/etc/selinux/mls/modules/semanage.trans.LOCK
	chmod 600 $(TMPTOP)/etc/selinux/mls/modules/semanage.trans.LOCK
	(cd $(SRCTOP)/debian/build-$(package);                                  \
            $(MAKE) NAME=mls TYPE=mls $(OPTIONS) \
                    DESTDIR=$(TMPTOP) install  install-headers                  \
          $(TMPTOP)/etc/selinux/mls/users/local.users              \
          $(TMPTOP)/etc/selinux/mls/users/system.users)
	for module in $(NON_MODULES); do                                         \
           test ! -f $(TMPTOP)/usr/share/selinux/mls/$$module.pp || \
              rm -f $(TMPTOP)/usr/share/selinux/mls/$$module.pp;    \
        done
	$(install_file)      debian/setrans.conf  $(TMPTOP)/etc/selinux/mls/
	$(install_file)      VERSION               $(DOCDIR)/
	$(install_file)      README                $(DOCDIR)/
	$(install_file)      debian/README.Debian  $(DOCDIR)/
	$(install_file)      debian/localStrict.te $(DOCDIR)/
	$(install_file)      debian/NEWS.Debian    $(DOCDIR)/NEWS.Debian 
	$(install_file)      Changelog             $(DOCDIR)/changelog
	$(install_file)      debian/changelog      $(DOCDIR)/changelog.Debian
	gzip -9fqr           $(DOCDIR)
	$(install_file)      debian/copyright      $(DOCDIR)/
DIRS_TO_CLEAN  += debian/selinux-policy-mls

install/selinux-policy-default:
	$(REASON)
	rm -rf               $(TMPTOP) $(TMPTOP).deb
	$(make_directory)    $(DOCDIR)/
	$(make_directory)    $(TMPTOP)/etc/selinux/default/modules/active
	$(make_directory)    $(TMPTOP)/etc/selinux/default/policy
	test -f $(TMPTOP)/etc/selinux/default/modules/active/file_contexts.local || \
	touch $(TMPTOP)/etc/selinux/default/modules/active/file_contexts.local
	touch $(TMPTOP)/etc/selinux/default/modules/semanage.read.LOCK
	chmod 600 $(TMPTOP)/etc/selinux/default/modules/semanage.read.LOCK
	touch $(TMPTOP)/etc/selinux/default/modules/semanage.trans.LOCK
	chmod 600 $(TMPTOP)/etc/selinux/default/modules/semanage.trans.LOCK
	(cd $(SRCTOP)/debian/build-$(package);                                      \
            $(MAKE) NAME=default TYPE=mcs $(OPTIONS) \
                    DESTDIR=$(TMPTOP) install  install-headers                      \
          $(TMPTOP)/etc/selinux/default/users/local.users                \
          $(TMPTOP)/etc/selinux/default/users/system.users)
	for module in $(NON_MODULES); do                                           \
           test ! -f $(TMPTOP)/usr/share/selinux/default/$$module.pp || \
             rm -f $(TMPTOP)/usr/share/selinux/default/$$module.pp;     \
        done
	$(install_file)      debian/setrans.conf  $(TMPTOP)/etc/selinux/default/
	$(install_file)      VERSION              $(DOCDIR)/
	$(install_file)      README               $(DOCDIR)/
	$(install_file)      debian/README.Debian $(DOCDIR)/
	$(install_file)      Changelog            $(DOCDIR)/changelog
	$(install_file)      debian/changelog     $(DOCDIR)/changelog.Debian
	gzip -9fqr           $(DOCDIR)
	$(install_file)      debian/copyright     $(DOCDIR)/
DIRS_TO_CLEAN  += debian/selinux-policy-default

install/selinux-policy-src:
	$(REASON)
	rm -rf               $(TMPTOP) $(TMPTOP).deb
	$(make_directory)    $(DOCDIR)
	$(make_directory)    $(TMPTOP)/usr/src
	(cd $(SRCTOP)/debian/build-$(package);                                 \
         $(MAKE) NAME=default $(OPTIONS) DESTDIR=$(TMPTOP) bare conf install-src; )
	find $(TMPTOP) -type d -name .arch-ids -print0 | xargs -0r rm -rf
	test ! -e $(TMPTOP)/etc/selinux/default/src/policy/COPYING || \
           rm -f $(TMPTOP)/etc/selinux/default/src/policy/COPYING
	rm -rf   $(TMPTOP)/etc/selinux/default/src/policy/man
	(cd $(TMPTOP)/etc/selinux/default/src/policy;                   \
          if test -f modules.conf; then                                   \
              mv modules.conf modules.conf.dist;                          \
          fi;                                                             \
          ln -sf modules.conf.mls modules.conf)
	$(install_file)      policy/rolemap                               \
			     $(TMPTOP)/etc/selinux/default/src/policy/
	$(install_file)      debian/build.conf.default                   \
			     $(TMPTOP)/etc/selinux/default/src/policy/build.conf
	$(install_file)      debian/global_booleans.xml                   \
			     $(TMPTOP)/etc/selinux/default/src/policy/
	$(install_file)      debian/global_tunables.xml                   \
			     $(TMPTOP)/etc/selinux/default/src/policy/
	$(install_file)      debian/Makefile.src                          \
                             $(TMPTOP)/etc/selinux/default/src/policy/
	(cd $(TMPTOP)/etc/selinux/default/src/; mv policy $(package);   \
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
DIRS_TO_CLEAN  += debian/selinux-policy-src

install/selinux-policy-dev: install/selinux-policy-mls install/selinux-policy-default
	$(REASON)
	rm -rf               $(TMPTOP) $(TMPTOP).deb
	$(make_directory)    $(DOCDIR)/examples
	$(make_directory)    $(MAN1DIR)
	$(make_directory)    $(TMPTOP)/usr/bin
	$(make_directory)    $(TMPTOP)/usr/share/selinux/mls/include
	$(make_directory)    $(TMPTOP)/usr/share/selinux/default/include
	find $(TMPTOP) -type d -name .arch-ids -print0 | xargs -0r rm -rf
	(cd $(SRCTOP)/debian/selinux-policy-mls/usr/share/selinux/mls; \
         tar cfh - include | (cd $(TMPTOP)/usr/share/selinux/mls; umask 000;        \
           tar xpsf -))
	(cd $(SRCTOP)/debian/selinux-policy-default/usr/share/selinux/default; \
         tar cfh - include | (cd $(TMPTOP)/usr/share/selinux/default; umask 000;      \
             tar xpsf -))
	rm -rf $(SRCTOP)/debian/selinux-policy-mls/usr/share/selinux/mls/include
	rm -rf $(SRCTOP)/debian/selinux-policy-default/usr/share/selinux/default/include
	$(install_file)      policy/rolemap                                                   \
                             $(TMPTOP)/usr/share/selinux/default/include/support
	$(install_file)      debian/global_booleans.xml                                       \
                             $(TMPTOP)/usr/share/selinux/default/include/support
	$(install_file)      debian/global_tunables.xml                                       \
                             $(TMPTOP)/usr/share/selinux/default/include/support
	$(install_file)      debian/build.conf.default                                       \
                             $(TMPTOP)/usr/share/selinux/default/include/build.conf
	$(install_file)      policy/rolemap                                                   \
                             $(TMPTOP)/usr/share/selinux/mls/include/support
	$(install_file)      debian/global_booleans.xml                                       \
                             $(TMPTOP)/usr/share/selinux/mls/include/support
	$(install_file)      debian/global_tunables.xml                                       \
                             $(TMPTOP)/usr/share/selinux/mls/include/support
	$(install_file)      debian/build.conf.mls                                         \
                             $(TMPTOP)/usr/share/selinux/mls/include/build.conf
	chmod +x             $(TMPTOP)/usr/share/selinux/default/include/support/segenxml.py
	chmod +x             $(TMPTOP)/usr/share/selinux/mls/include/support/segenxml.py
	$(install_file)      VERSION                $(DOCDIR)/
	$(install_file)      README                 $(DOCDIR)/
	$(install_file)      debian/README.Debian   $(DOCDIR)/
	$(install_file)      Changelog              $(DOCDIR)/changelog
	$(install_file)      debian/changelog       $(DOCDIR)/changelog.Debian
	gzip -9fqr           $(DOCDIR)
	$(install_file)      debian/copyright       $(DOCDIR)/
	$(install_file)      debian/example.fc      $(DOCDIR)/examples/
	$(install_file)      debian/example.if      $(DOCDIR)/examples/
	$(install_file)      debian/example.te      $(DOCDIR)/examples/
	$(install_file)      debian/example.mk      $(DOCDIR)/examples/Makefile
	$(install_program)   debian/policygentool   $(TMPTOP)/usr/bin
	$(install_file)      debian/policygentool.1 $(MAN1DIR)
	gzip -9fqr           $(MAN1DIR)
DIRS_TO_CLEAN  += debian/selinux-policy-dev

install/selinux-policy-doc:
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
         $(MAKE) NAME=default $(OPTIONS) DESTDIR=$(TMPTOP)                     \
                 PKGNAME=selinux-policy-doc conf html install-docs;)
	gzip -9fq $(DOCDIR)/example.if $(DOCDIR)/example.fc $(DOCDIR)/Makefile.example 
	$(install_file)      debian/copyright     $(DOCDIR)/
	$(install_file)      debian/docentry         $(DOCBASEDIR)/$(package)
DIRS_TO_CLEAN  += debian/selinux-policy-doc

binary/selinux-policy-mls:
	$(REASON)
	$(checkdir)
	$(make_directory)    $(TMPTOP)/DEBIAN
	(cd $(TMPTOP); find etc -type f | sed 's,^,/,' > DEBIAN/conffiles)
	test ! -f DEBIAN/conffiles || test -s DEBIAN/conffiles || rm DEBIAN/conffiles
	sed -e 's/=T/mls/g' debian/postinst.policy  > $(TMPTOP)/DEBIAN/postinst
	chmod 755                                      $(TMPTOP)/DEBIAN/postinst
	$(install_program)   debian/mls.postrm      $(TMPTOP)/DEBIAN/postrm
	dpkg-gencontrol    -V'debconf-depends=debconf (>= $(MINDEBCONFVER))' \
                              -p$(package) -isp   -P$(TMPTOP)
	$(create_md5sum)     $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..

binary/selinux-policy-default:
	$(REASON)
	$(checkdir)
	$(make_directory)    $(TMPTOP)/DEBIAN
	(cd $(TMPTOP); find etc -type f | sed 's,^,/,'  > DEBIAN/conffiles)
	test ! -f DEBIAN/conffiles || test -s DEBIAN/conffiles || rm DEBIAN/conffiles
	sed -e 's/=T/default/g' debian/postinst.policy >$(TMPTOP)/DEBIAN/postinst
	chmod 755                                       $(TMPTOP)/DEBIAN/postinst
	$(install_program)   debian/default.postrm     $(TMPTOP)/DEBIAN/postrm
	dpkg-gencontrol    -V'debconf-depends=debconf (>= $(MINDEBCONFVER))' \
                              -p$(package) -isp   -P$(TMPTOP)
	$(create_md5sum)   $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..

binary/selinux-policy-src:
	$(REASON)
	$(checkdir)
	$(make_directory)    $(TMPTOP)/DEBIAN
	dpkg-gencontrol    -V'debconf-depends=debconf (>= $(MINDEBCONFVER))' \
                              -p$(package) -isp   -P$(TMPTOP)
	$(create_md5sum)   $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..

binary/selinux-policy-dev:
	$(REASON)
	$(checkdir)
	$(make_directory)    $(TMPTOP)/DEBIAN
	dpkg-gencontrol    -V'debconf-depends=debconf (>= $(MINDEBCONFVER))' \
                              -p$(package) -isp   -P$(TMPTOP)
	$(create_md5sum)   $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..

binary/selinux-policy-doc:
	$(REASON)
	$(checkdir)
	$(make_directory)    $(TMPTOP)/DEBIAN
	(cd $(TMPTOP); find etc -type f | sed 's,^,/,' > DEBIAN/conffiles)
	test ! -f DEBIAN/conffiles || test -s DEBIAN/conffiles || rm DEBIAN/conffiles
	$(install_program)   debian/doc.postinst      $(TMPTOP)/DEBIAN/postinst
	$(install_program)   debian/doc.prerm         $(TMPTOP)/DEBIAN/prerm
	dpkg-gencontrol    -V'debconf-depends=debconf (>= $(MINDEBCONFVER))' \
                              -p$(package) -isp   -P$(TMPTOP)
	$(create_md5sum)   $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..


