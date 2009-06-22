############################ -*- Mode: Makefile -*- ###########################
## local.mk --- 
## Author           : Manoj Srivastava ( srivasta@glaurung.green-gryphon.com ) 
## Created On       : Sat Nov 15 10:42:10 2003
## Created On Node  : glaurung.green-gryphon.com
## Last Modified By : Manoj Srivastava
## Last Modified On : Sat Feb 14 15:46:22 2009
## Last Machine Used: anzu.internal.golden-gryphon.com
## Update Count     : 130
## Status           : Unknown, Use with caution!
## HISTORY          : 
## Description      : 
## 
## arch-tag: b07b1015-30ba-4b46-915f-78c776a808f4
## 
###############################################################################

testdir:
	$(testdir)

debian/stamp/pre-config-common:   debian/stamp/conf/common
debian/stamp/pre-build-common:    debian/stamp/build/common

debian/stamp/CONFIG/selinux-policy-mls: debian/stamp/conf/selinux-policy-mls
debian/stamp/BUILD/selinux-policy-mls: debian/stamp/build/selinux-policy-mls
debian/stamp/INST/selinux-policy-mls:  debian/stamp/install/selinux-policy-mls
debian/stamp/BIN/selinux-policy-mls:   debian/stamp/binary/selinux-policy-mls

debian/stamp/CONFIG/selinux-policy-default: debian/stamp/conf/selinux-policy-default
debian/stamp/BUILD/selinux-policy-default: debian/stamp/build/selinux-policy-default
debian/stamp/INST/selinux-policy-default:  debian/stamp/install/selinux-policy-default
debian/stamp/BIN/selinux-policy-default:   debian/stamp/binary/selinux-policy-default


debian/stamp/CONFIG/selinux-policy-src: debian/stamp/conf/selinux-policy-src
debian/stamp/BUILD/selinux-policy-src: debian/stamp/build/selinux-policy-src
debian/stamp/INST/selinux-policy-src:  debian/stamp/install/selinux-policy-src
debian/stamp/BIN/selinux-policy-src:   debian/stamp/binary/selinux-policy-src

debian/stamp/CONFIG/selinux-policy-dev: debian/stamp/conf/selinux-policy-dev
debian/stamp/BUILD/selinux-policy-dev: debian/stamp/build/selinux-policy-dev
debian/stamp/INST/selinux-policy-dev:  debian/stamp/install/selinux-policy-dev
debian/stamp/BIN/selinux-policy-dev:   debian/stamp/binary/selinux-policy-dev


debian/stamp/CONFIG/selinux-policy-doc: debian/stamp/conf/selinux-policy-doc
debian/stamp/BUILD/selinux-policy-doc: debian/stamp/build/selinux-policy-doc
debian/stamp/INST/selinux-policy-doc:  debian/stamp/install/selinux-policy-doc
debian/stamp/BIN/selinux-policy-doc:   debian/stamp/binary/selinux-policy-doc

CLEAN/selinux-policy-mls CLEAN/selinux-policy-default CLEAN/selinux-policy-src CLEAN/selinux-policy-src CLEAN/selinux-policy-dev CLEAN/selinux-policy-doc ::
	$(REASON)
	-test -f Makefile && $(MAKE) bare
	test ! -d $(TMPTOP) || rm -rf $(TMPTOP)
	test ! -d $(SRCTOP)/debian/build-$(package) || \
                                      rm -rf $(SRCTOP)/debian/build-$(package)

debian/stamp/conf/common:
	$(REASON)
	$(checkdir)
	@test -d debian/stamp/conf || mkdir -p debian/stamp/conf
	test -d $(SRCTOP)/config/appconfig-mcs  || \
            cp -a $(SRCTOP)/config/appconfig-mcs $(SRCTOP)/config/appconfig-default
	test -d $(SRCTOP)/config/appconfig-mcs  || \
            cp -a $(SRCTOP)/config/appconfig-mls $(SRCTOP)/config/appconfig-mls
	echo done > $@

debian/stamp/conf/selinux-policy-mls:
	$(REASON)
	$(checkdir)
	@test -d debian/stamp/conf || mkdir -p debian/stamp/conf
	test ! -d $(SRCTOP)/debian/build-$(package) ||                   \
            rm -rf $(SRCTOP)/debian/build-$(package)
	mkdir -p    $(SRCTOP)/debian/build-$(package)
	test -e debian/stamp-config-mls  ||                             \
	  cp -lr policy support Makefile Rules.modular  doc                \
               Rules.monolithic config VERSION Changelog COPYING INSTALL   \
                README man $(SRCTOP)/debian/build-$(package)
	cp debian/build.conf.mls $(SRCTOP)/debian/build-$(package)/build.conf
	$(MAKE) -C $(SRCTOP)/debian/build-$(package)                     \
                   NAME=mls TYPE=mls $(OPTIONS) bare
	(cd $(SRCTOP)/debian/build-$(package) ;                          \
           $(MAKE) NAME=mls TYPE=mls $(OPTIONS) conf)
	cp debian/modules.conf.mls                                      \
                     $(SRCTOP)/debian/build-$(package)/policy/modules.conf
	echo done > $@

debian/stamp/conf/selinux-policy-default:
	$(REASON)
	$(checkdir)
	@test -d debian/stamp/conf || mkdir -p debian/stamp/conf
	test ! -d $(SRCTOP)/debian/build-$(package) ||                   \
            rm -rf $(SRCTOP)/debian/build-$(package)
	mkdir -p    $(SRCTOP)/debian/build-$(package)
	cp -lr policy support Makefile  Rules.modular  doc               \
               Rules.monolithic config VERSION Changelog COPYING INSTALL   \
                README man $(SRCTOP)/debian/build-$(package)
	cp debian/build.conf.default $(SRCTOP)/debian/build-$(package)/build.conf
	$(MAKE) -C $(SRCTOP)/debian/build-$(package)                     \
                 NAME=default TYPE=mcs $(OPTIONS) bare
	(cd $(SRCTOP)/debian/build-$(package) ;                          \
           $(MAKE) NAME=default TYPE=mcs $(OPTIONS) conf)
	cp debian/modules.conf.default                                    \
                     $(SRCTOP)/debian/build-$(package)/policy/modules.conf
	echo done > $@

debian/stamp/conf/selinux-policy-src:
	$(REASON)
	$(checkdir)
	@test -d debian/stamp/conf || mkdir -p debian/stamp/conf
	test ! -d $(SRCTOP)/debian/build-$(package) ||                  \
            rm -rf $(SRCTOP)/debian/build-$(package)
	mkdir -p    $(SRCTOP)/debian/build-$(package)
	cp -lr policy support Makefile Rules.modular  doc               \
               Rules.monolithic config VERSION Changelog COPYING INSTALL  \
                README man $(SRCTOP)/debian/build-$(package)
	cp  debian/build.conf.default $(SRCTOP)/debian/build-$(package)/build.conf
	(cd $(SRCTOP)/debian/build-$(package) ;                         \
           $(MAKE) NAME=default $(OPTIONS) conf)
	cp debian/modules.conf.*      $(SRCTOP)/debian/build-$(package)/policy/
	cp debian/build.conf.default $(SRCTOP)/debian/build-$(package)/policy/
	echo done > $@

debian/stamp/conf/selinux-policy-dev:
	$(REASON)
	$(checkdir)
	@test -d debian/stamp/conf || mkdir -p debian/stamp/conf
	test ! -d $(SRCTOP)/debian/build-$(package) ||                  \
            rm -rf $(SRCTOP)/debian/build-$(package)
	mkdir -p    $(SRCTOP)/debian/build-$(package)
	echo done > $@

debian/stamp/conf/selinux-policy-doc::
	$(REASON)
	$(checkdir)
	@test -d debian/stamp/conf || mkdir -p debian/stamp/conf
	test ! -d $(SRCTOP)/debian/build-$(package) ||                   \
            rm -rf $(SRCTOP)/debian/build-$(package)
	mkdir -p    $(SRCTOP)/debian/build-$(package)
	cp -lr policy support Makefile Rules.modular  doc                \
               Rules.monolithic config VERSION Changelog COPYING INSTALL   \
                README man $(SRCTOP)/debian/build-$(package)
	cp  debian/build.conf.default $(SRCTOP)/debian/build-$(package)/build.conf
	(cd $(SRCTOP)/debian/build-$(package) ;                          \
           $(MAKE) NAME=default $(OPTIONS) conf )
	echo done > $@

debian/stamp/build/common:
	$(REASON)
	$(checkdir)
	@test -d debian/stamp/build || mkdir -p debian/stamp/build
	perl -wc debian/postinst.policy
	echo done > $@

debian/stamp/build/selinux-policy-mls:
	$(REASON)
	$(checkdir)
	@test -d debian/stamp/build || mkdir -p debian/stamp/build
	test -e debian/stamp-build-mls                    ||            \
	  (cd $(SRCTOP)/debian/build-$(package) ;                          \
           $(MAKE) NAME=mls TYPE=mls $(OPTIONS) policy all)
	echo done > $@ 

debian/stamp/build/selinux-policy-default:
	$(REASON)
	$(checkdir)
	@test -d debian/stamp/build || mkdir -p debian/stamp/build
	(cd $(SRCTOP)/debian/build-$(package) ;                            \
           $(MAKE) NAME=default TYPE=mcs $(OPTIONS) policy all)
	echo done > $@ 

debian/stamp/build/selinux-policy-src:
	$(REASON)
	$(checkdir)
	@test -d debian/stamp/build || mkdir -p debian/stamp/build
	echo done > $@ 

debian/stamp/build/selinux-policy-dev:
	$(REASON)
	$(checkdir)
	@test -d debian/stamp/build || mkdir -p debian/stamp/build
	echo done > $@ 

debian/stamp/build/selinux-policy-doc:
	$(REASON)
	$(checkdir)
	@test -d debian/stamp/build || mkdir -p debian/stamp/build
	echo done > $@ 


debian/stamp/install/selinux-policy-mls:
	$(REASON)
	$(checkdir)
	$(TESTROOT)
	@test -d debian/stamp/install || mkdir -p debian/stamp/install
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
	echo done > $@ 

debian/stamp/install/selinux-policy-default:
	$(REASON)
	$(checkdir)
	$(TESTROOT)
	@test -d debian/stamp/install || mkdir -p debian/stamp/install
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
	echo done > $@ 

debian/stamp/install/selinux-policy-src:
	$(REASON)
	$(checkdir)
	$(TESTROOT)
	@test -d debian/stamp/install || mkdir -p debian/stamp/install
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
	echo done > $@ 

debian/stamp/install/selinux-policy-dev: debian/stamp/install/selinux-policy-mls debian/stamp/install/selinux-policy-default
	$(REASON)
	$(checkdir)
	$(TESTROOT)
	@test -d debian/stamp/install || mkdir -p debian/stamp/install
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
	echo done > $@ 

debian/stamp/install/selinux-policy-doc:
	$(REASON)
	$(checkdir)
	$(TESTROOT)
	@test -d debian/stamp/install || mkdir -p debian/stamp/install
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
	echo done > $@ 

debian/stamp/binary/selinux-policy-mls:
	$(REASON)
	$(checkdir)
	$(TESTROOT)
	@test -d debian/stamp/binary || mkdir -p debian/stamp/binary
	$(make_directory)    $(TMPTOP)/DEBIAN
	(cd $(TMPTOP); find etc -type f | sed 's,^,/,' > DEBIAN/conffiles)
	test ! -f $(TMPTOP)/DEBIAN/conffiles || test -s $(TMPTOP)/DEBIAN/conffiles || \
           rm $(TMPTOP)/DEBIAN/conffiles
	sed -e 's/=T/mls/g' debian/postinst.policy  > $(TMPTOP)/DEBIAN/postinst
	chmod 755                                      $(TMPTOP)/DEBIAN/postinst
	$(install_program)   debian/mls.postrm      $(TMPTOP)/DEBIAN/postrm
	dpkg-gencontrol    -V'debconf-depends=debconf (>= $(MINDEBCONFVER))' \
                              -p$(package) -isp   -P$(TMPTOP)
	$(create_md5sum)     $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..
	echo done > $@ 

debian/stamp/binary/selinux-policy-default:
	$(REASON)
	$(checkdir)
	$(TESTROOT)
	@test -d debian/stamp/binary || mkdir -p debian/stamp/binary
	$(make_directory)    $(TMPTOP)/DEBIAN
	(cd $(TMPTOP); find etc -type f | sed 's,^,/,'  > DEBIAN/conffiles)
	test ! -f $(TMPTOP)/DEBIAN/conffiles || test -s $(TMPTOP)/DEBIAN/conffiles ||\
           rm $(TMPTOP)/DEBIAN/conffiles
	sed -e 's/=T/default/g' debian/postinst.policy >$(TMPTOP)/DEBIAN/postinst
	chmod 755                                       $(TMPTOP)/DEBIAN/postinst
	$(install_program)   debian/default.postrm     $(TMPTOP)/DEBIAN/postrm
	dpkg-gencontrol    -V'debconf-depends=debconf (>= $(MINDEBCONFVER))' \
                              -p$(package) -isp   -P$(TMPTOP)
	$(create_md5sum)   $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..
	echo done > $@ 

debian/stamp/binary/selinux-policy-src:
	$(REASON)
	$(checkdir)
	$(TESTROOT)
	@test -d debian/stamp/binary || mkdir -p debian/stamp/binary
	$(make_directory)    $(TMPTOP)/DEBIAN
	dpkg-gencontrol    -V'debconf-depends=debconf (>= $(MINDEBCONFVER))' \
                              -p$(package) -isp   -P$(TMPTOP)
	$(create_md5sum)   $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..
	echo done > $@ 

debian/stamp/binary/selinux-policy-dev:
	$(REASON)
	$(checkdir)
	$(TESTROOT)
	@test -d debian/stamp/binary || mkdir -p debian/stamp/binary
	$(make_directory)    $(TMPTOP)/DEBIAN
	dpkg-gencontrol    -V'debconf-depends=debconf (>= $(MINDEBCONFVER))' \
                              -p$(package) -isp   -P$(TMPTOP)
	$(create_md5sum)   $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..
	echo done > $@ 

debian/stamp/binary/selinux-policy-doc:
	$(REASON)
	$(checkdir)
	$(TESTROOT)
	@test -d debian/stamp/binary || mkdir -p debian/stamp/binary
	$(make_directory)    $(TMPTOP)/DEBIAN
	(cd $(TMPTOP); find etc -type f | sed 's,^,/,' > DEBIAN/conffiles)
	test ! -f $(TMPTOP)/DEBIAN/conffiles || test -s $(TMPTOP)/DEBIAN/conffiles || \
           rm $(TMPTOP)/DEBIAN/conffiles
	$(install_program)   debian/doc.postinst      $(TMPTOP)/DEBIAN/postinst
	$(install_program)   debian/doc.prerm         $(TMPTOP)/DEBIAN/prerm
	dpkg-gencontrol    -V'debconf-depends=debconf (>= $(MINDEBCONFVER))' \
                              -p$(package) -isp   -P$(TMPTOP)
	$(create_md5sum)   $(TMPTOP)
	chown -R root:root $(TMPTOP)
	chmod -R u+w,go=rX $(TMPTOP)
	dpkg --build       $(TMPTOP) ..
	echo done > $@ 


