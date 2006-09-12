#
# Makefile for the security policy.
#
# Targets:
# 
# install       - compile and install the policy configuration, and context files.
# load          - compile, install, and load the policy configuration.
# reload        - compile, install, and load/reload the policy configuration.
# relabel       - relabel filesystems based on the file contexts configuration.
# checklabels   - check filesystems against the file context configuration
# restorelabels - check filesystems against the file context configuration
#                 and restore the label of files with incorrect labels
# policy        - compile the policy configuration locally for testing/development.
#
# The default target is 'policy'.
#
#
# Please see build.conf for policy build options.
#

########################################
#
# NO OPTIONS BELOW HERE
#

# Include the local build.conf if it exists, otherwise
# include the configuration of the root directory.
include build.conf

ifdef LOCAL_ROOT
	-include $(LOCAL_ROOT)/build.conf
endif

# refpolicy version
version = $(shell cat VERSION)

ifdef LOCAL_ROOT
builddir := $(LOCAL_ROOT)/
tmpdir := $(LOCAL_ROOT)/tmp
tags := $(LOCAL_ROOT)/tags
else
tmpdir := tmp
tags := tags
endif

# executable paths
BINDIR ?= /usr/bin
SBINDIR ?= /usr/sbin
ifdef TEST_TOOLCHAIN
tc_usrbindir := env LD_LIBRARY_PATH="$(TEST_TOOLCHAIN)/lib" $(TEST_TOOLCHAIN)$(BINDIR)
tc_usrsbindir := env LD_LIBRARY_PATH="$(TEST_TOOLCHAIN)/lib" $(TEST_TOOLCHAIN)$(SBINDIR)
tc_sbindir := env LD_LIBRARY_PATH="$(TEST_TOOLCHAIN)/lib" $(TEST_TOOLCHAIN)/sbin
else
tc_usrbindir := $(BINDIR)
tc_usrsbindir := $(SBINDIR)
tc_sbindir := /sbin
endif
CHECKPOLICY ?= $(tc_usrbindir)/checkpolicy
CHECKMODULE ?= $(tc_usrbindir)/checkmodule
SEMODULE ?= $(tc_usrsbindir)/semodule
SEMOD_PKG ?= $(tc_usrbindir)/semodule_package
SEMOD_LNK ?= $(tc_usrbindir)/semodule_link
SEMOD_EXP ?= $(tc_usrbindir)/semodule_expand
LOADPOLICY ?= $(tc_usrsbindir)/load_policy
SETFILES ?= $(tc_sbindir)/setfiles
XMLLINT ?= $(BINDIR)/xmllint
SECHECK ?= $(BINDIR)/sechecker

# interpreters and aux tools
AWK ?= gawk
GREP ?= egrep
INSTALL ?= install
M4 ?= m4
PYTHON ?= python
SED ?= sed
SORT ?= LC_ALL=C sort

CFLAGS += -Wall

# policy source layout
poldir := policy
moddir := $(poldir)/modules
flaskdir := $(poldir)/flask
secclass := $(flaskdir)/security_classes
isids := $(flaskdir)/initial_sids
avs := $(flaskdir)/access_vectors

# local source layout
ifdef LOCAL_ROOT
local_poldir := $(LOCAL_ROOT)/policy
local_moddir := $(local_poldir)/modules
endif

# policy building support tools
support := support
genxml := $(PYTHON) $(support)/segenxml.py
gendoc := $(PYTHON) $(support)/sedoctool.py
genperm := $(PYTHON) $(support)/genclassperms.py
fcsort := $(tmpdir)/fc_sort
setbools := $(AWK) -f $(support)/set_bools_tuns.awk
get_type_attr_decl := $(SED) -r -f $(support)/get_type_attr_decl.sed
comment_move_decl := $(SED) -r -f $(support)/comment_move_decl.sed
gennetfilter := $(PYTHON) $(support)/gennetfilter.py
# use our own genhomedircon to make sure we have a known usable one,
# so policycoreutils updates are not required (RHEL4)
genhomedircon := $(PYTHON) $(support)/genhomedircon

# documentation paths
docs := doc
xmldtd = $(docs)/policy.dtd
layerxml = metadata.xml
doctemplate = $(docs)/templates
docfiles = $(docs)/Makefile.example $(addprefix $(docs)/,example.te example.if example.fc)

ifndef LOCAL_ROOT
polxml = $(docs)/policy.xml
tunxml = $(docs)/global_tunables.xml
boolxml = $(docs)/global_booleans.xml
htmldir = $(docs)/html
else
polxml = $(LOCAL_ROOT)/doc/policy.xml
tunxml = $(LOCAL_ROOT)/doc/global_tunables.xml
boolxml = $(LOCAL_ROOT)/doc/global_booleans.xml
htmldir = $(LOCAL_ROOT)/doc/html
endif

# config file paths
globaltun = $(poldir)/global_tunables
globalbool = $(poldir)/global_booleans
rolemap = $(poldir)/rolemap
user_files := $(poldir)/users

# local config file paths
ifndef LOCAL_ROOT
mod_conf = $(poldir)/modules.conf
booleans = $(poldir)/booleans.conf
tunables = $(poldir)/tunables.conf
else
mod_conf = $(local_poldir)/modules.conf
booleans = $(local_poldir)/booleans.conf
tunables = $(local_poldir)/tunables.conf
endif

# install paths
PKGNAME ?= refpolicy-$(version)
prefix = $(DESTDIR)/usr
topdir = $(DESTDIR)/etc/selinux
installdir = $(topdir)/$(strip $(NAME))
srcpath = $(installdir)/src
userpath = $(installdir)/users
contextpath = $(installdir)/contexts
fcpath = $(contextpath)/files/file_contexts
ncpath = $(contextpath)/netfilter_contexts
sharedir = $(prefix)/share/selinux
modpkgdir = $(sharedir)/$(strip $(NAME))
headerdir = $(modpkgdir)/include
docsdir = $(prefix)/share/doc/$(PKGNAME)

# compile strict policy if requested.
ifneq ($(findstring strict,$(TYPE)),)
	M4PARAM += -D strict_policy
endif

# compile targeted policy if requested.
ifneq ($(findstring targeted,$(TYPE)),)
	M4PARAM += -D targeted_policy
endif

# enable MLS if requested.
ifneq ($(findstring -mls,$(TYPE)),)
	M4PARAM += -D enable_mls
	CHECKPOLICY += -M
	CHECKMODULE += -M
	gennetfilter += -m
endif

# enable MLS if MCS requested.
ifneq ($(findstring -mcs,$(TYPE)),)
	M4PARAM += -D enable_mcs
	CHECKPOLICY += -M
	CHECKMODULE += -M
	gennetfilter += -c
endif

# enable distribution-specific policy
ifneq ($(DISTRO),)
	M4PARAM += -D distro_$(DISTRO)
endif

# rhel4 also implies redhat
ifeq "$(DISTRO)" "rhel4"
	M4PARAM += -D distro_redhat
endif

# enable polyinstantiation
ifeq ($(POLY),y)
	M4PARAM += -D enable_polyinstantiation
endif

ifneq ($(OUTPUT_POLICY),)
	CHECKPOLICY += -c $(OUTPUT_POLICY)
endif

# if not set, use the type as the name.
NAME ?= $(TYPE)

ifeq ($(DIRECT_INITRC),y)
	M4PARAM += -D direct_sysadm_daemon
endif

ifeq ($(QUIET),y)
	verbose = @
endif

M4PARAM += -D hide_broken_symptoms

# we need exuberant ctags; unfortunately it is named
# differently on different distros
ifeq ($(DISTRO),debian)
	CTAGS := ctags-exuberant
endif

ifeq ($(DISTRO),gentoo)
	CTAGS := exuberant-ctags	
endif

CTAGS ?= ctags

m4support := $(wildcard $(poldir)/support/*.spt)
ifdef LOCAL_ROOT
m4support += $(wildcard $(local_poldir)/support/*.spt)
endif

appconf := config/appconfig-$(TYPE)
seusers := $(appconf)/seusers
appdir := $(contextpath)
appfiles := $(addprefix $(appdir)/,default_contexts default_type initrc_context failsafe_context userhelper_context removable_context dbus_contexts customizable_types) $(contextpath)/files/media
net_contexts := $(builddir)net_contexts

all_layers := $(filter-out $(moddir)/CVS,$(shell find $(wildcard $(moddir)/*) -maxdepth 0 -type d))
ifdef LOCAL_ROOT
all_layers += $(filter-out $(local_moddir)/CVS,$(shell find $(wildcard $(local_moddir)/*) -maxdepth 0 -type d))
endif

generated_te := $(basename $(foreach dir,$(all_layers),$(wildcard $(dir)/*.te.in)))
generated_if := $(basename $(foreach dir,$(all_layers),$(wildcard $(dir)/*.if.in)))
generated_fc := $(basename $(foreach dir,$(all_layers),$(wildcard $(dir)/*.fc.in)))

# sort here since it removes duplicates, which can happen
# when a generated file is already generated
detected_mods := $(sort $(foreach dir,$(all_layers),$(wildcard $(dir)/*.te)) $(generated_te))

# modules.conf setting for base module
configbase := base

# modules.conf setting for loadable module
configmod := module

# modules.conf setting for unused module
configoff := off

# test for module overrides from command line
mod_test = $(filter $(APPS_OFF), $(APPS_BASE) $(APPS_MODS))
mod_test += $(filter $(APPS_MODS), $(APPS_BASE))
ifneq "$(strip $(mod_test))" ""
        $(error Applications must be base, module, or off, and not in more than one list! $(strip $(mod_test)) found in multiple lists!)
endif

# add on suffix to modules specified on command line
cmdline_base := $(addsuffix .te,$(APPS_BASE))
cmdline_mods := $(addsuffix .te,$(APPS_MODS))
cmdline_off := $(addsuffix .te,$(APPS_OFF))

# extract settings from modules.conf
mod_conf_base := $(addsuffix .te,$(sort $(shell awk '/^[[:blank:]]*[[:alpha:]]/{ if ($$3 == "$(configbase)") print $$1 }' $(mod_conf) 2> /dev/null)))
mod_conf_mods := $(addsuffix .te,$(sort $(shell awk '/^[[:blank:]]*[[:alpha:]]/{ if ($$3 == "$(configmod)") print $$1 }' $(mod_conf) 2> /dev/null)))
mod_conf_off := $(addsuffix .te,$(sort $(shell awk '/^[[:blank:]]*[[:alpha:]]/{ if ($$3 == "$(configoff)") print $$1 }' $(mod_conf) 2> /dev/null)))

base_mods := $(cmdline_base)
mod_mods := $(cmdline_mods)
off_mods := $(cmdline_off)

base_mods += $(filter-out $(cmdline_off) $(cmdline_base) $(cmdline_mods), $(mod_conf_base))
mod_mods += $(filter-out $(cmdline_off) $(cmdline_base) $(cmdline_mods), $(mod_conf_mods))
off_mods += $(filter-out $(cmdline_off) $(cmdline_base) $(cmdline_mods), $(mod_conf_off))

# add modules not in modules.conf to the off list
off_mods += $(filter-out $(base_mods) $(mod_mods) $(off_mods),$(notdir $(detected_mods)))

# filesystems to be used in labeling targets
filesystems = $(shell mount | grep -v "context=" | egrep -v '\((|.*,)bind(,.*|)\)' | awk '/(ext[23]| xfs| jfs).*rw/{print $$3}';)

########################################
#
# Functions
#

# parse-rolemap-compat modulename,outputfile
define parse-rolemap-compat
	$(verbose) $(M4) $(M4PARAM) $(rolemap) | \
		$(AWK) '/^[[:blank:]]*[A-Za-z]/{ print "gen_require(type " $$3 "; role " $$1 ";)\n$1_per_userdomain_template(" $$2 "," $$3 "," $$1 ")" }' >> $2
endef

# parse-rolemap modulename,outputfile
define parse-rolemap
	$(verbose) $(M4) $(M4PARAM) $(rolemap) | \
		$(AWK) '/^[[:blank:]]*[A-Za-z]/{ print "gen_require(type " $$3 "; role " $$1 ";)\n$1_per_role_template(" $$2 "," $$3 "," $$1 ")" }' >> $2
endef

# perrole-expansion modulename,outputfile
define perrole-expansion
	$(verbose) echo "ifdef(\`""$1""_per_role_template',\`" > $2
	$(call parse-rolemap,$1,$2)
	$(verbose) echo "')" >> $2

	$(verbose) echo "ifdef(\`""$1""_per_userdomain_template',\`" >> $2
	$(verbose) echo "errprint(\`Warning: per_userdomain_templates have been renamed to per_role_templates (""$1""_per_userdomain_template)'__endline__)" >> $2
	$(call parse-rolemap-compat,$1,$2)
	$(verbose) echo "')" >> $2
endef

# create-base-per-role-tmpl modulenames,outputfile
define create-base-per-role-tmpl
	$(verbose) echo "define(\`base_per_role_template',\`" >> $2

	$(verbose) for i in $1; do \
		echo "ifdef(\`""$$i""_per_role_template',\`""$$i""_per_role_template("'$$*'")')" \
			>> $2 ;\
	done

	$(verbose) for i in $1; do \
		echo "ifdef(\`""$$i""_per_userdomain_template',\`" >> $2 ;\
		echo "errprint(\`Warning: per_userdomain_templates have been renamed to per_role_templates (""$$i""_per_userdomain_template)'__endline__)" >> $2 ;\
		echo """$$i""_per_userdomain_template("'$$*'")')"  >> $2 ;\
	done
	$(verbose) echo "')" >> $@

endef

########################################
#
# Load appropriate rules
#

ifeq ($(MONOLITHIC),y)
	include Rules.monolithic
else
	include Rules.modular
endif

########################################
#
# Generated files
#
# NOTE: There is no "local" version of these files.
#
generate: $(generated_te) $(generated_if) $(generated_fc)

$(moddir)/kernel/corenetwork.if: $(moddir)/kernel/corenetwork.te.in $(moddir)/kernel/corenetwork.if.m4 $(moddir)/kernel/corenetwork.if.in
	@echo "#" > $@
	@echo "# This is a generated file!  Instead of modifying this file, the" >> $@
	@echo "# $(notdir $@).in or $(notdir $@).m4 file should be modified." >> $@
	@echo "#" >> $@
	$(verbose) cat $@.in >> $@
	$(verbose) $(GREP) "^[[:blank:]]*network_(interface|node|port|packet)\(.*\)" $< \
		| $(M4) -D self_contained_policy $(M4PARAM) $@.m4 - \
		| $(SED) -e 's/dollarsone/\$$1/g' -e 's/dollarszero/\$$0/g' >> $@

$(moddir)/kernel/corenetwork.te: $(moddir)/kernel/corenetwork.te.m4 $(moddir)/kernel/corenetwork.te.in
	@echo "#" > $@
	@echo "# This is a generated file!  Instead of modifying this file, the" >> $@
	@echo "# $(notdir $@).in or $(notdir $@).m4 file should be modified." >> $@
	@echo "#" >> $@
	$(verbose) $(M4) -D self_contained_policy $(M4PARAM) $^ \
		| $(SED) -e 's/dollarsone/\$$1/g' -e 's/dollarszero/\$$0/g' >> $@

########################################
#
# Network packet labeling
#
$(net_contexts): $(moddir)/kernel/corenetwork.te.in
	@echo "Creating netfilter network labeling rules"
	$(verbose) $(gennetfilter) $^ > $@

########################################
#
# Create config files
#
conf: $(mod_conf) $(booleans) $(generated_te) $(generated_if) $(generated_fc)

$(mod_conf) $(booleans): $(polxml)
	@echo "Updating $(mod_conf) and $(booleans)"
	$(verbose) $(gendoc) -b $(booleans) -m $(mod_conf) -x $(polxml)

########################################
#
# Generate the fc_sort program
#
$(fcsort) : $(support)/fc_sort.c
	$(verbose) $(CC) $(CFLAGS) $(support)/fc_sort.c -o $(fcsort)

########################################
#
# Documentation generation
#

# minimal dependencies here, because we don't want to rebuild 
# this and its dependents every time the dependencies
# change.  Also use all .if files here, rather then just the
# enabled modules.
xml: $(polxml)
$(polxml): $(detected_mods:.te=.if) $(foreach dir,$(all_layers),$(dir)/$(layerxml))
	@echo "Creating $(@F)"
	@test -d $(dir $(polxml)) || mkdir -p $(dir $(polxml))
	@test -d $(tmpdir) || mkdir -p $(tmpdir)
	$(verbose) echo '<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>' > $@
	$(verbose) echo '<!DOCTYPE policy SYSTEM "$(notdir $(xmldtd))">' >> $@
	$(verbose) $(genxml) -w -m $(layerxml) -t $(globaltun) -b $(globalbool) -o $(docs) $(all_layers) >> $@
	$(verbose) if test -x $(XMLLINT) && test -f $(xmldtd); then \
		$(XMLLINT) --noout --path $(dir $(xmldtd)) --dtdvalid $(xmldtd) $@ ;\
	fi

$(tunxml) $(boolxml): $(polxml)

html $(tmpdir)/html: $(polxml)
	@echo "Building html interface reference documentation in $(htmldir)"
	@test -d $(htmldir) || mkdir -p $(htmldir)
	@test -d $(tmpdir) || mkdir -p $(tmpdir)
	$(verbose) $(gendoc) -d $(htmldir) -T $(doctemplate) -x $(polxml)
	$(verbose) cp $(doctemplate)/*.css $(htmldir)
	@touch $(tmpdir)/html

########################################
#
# Runtime binary policy patching of users
#
$(userpath)/system.users: $(m4support) $(tmpdir)/generated_definitions.conf $(user_files)
	@mkdir -p $(tmpdir)
	@mkdir -p $(userpath)
	@echo "Installing system.users"
	@echo "# " > $(tmpdir)/system.users
	@echo "# Do not edit this file. " >> $(tmpdir)/system.users
	@echo "# This file is replaced on reinstalls of this policy." >> $(tmpdir)/system.users
	@echo "# Please edit local.users to make local changes." >> $(tmpdir)/system.users
	@echo "#" >> $(tmpdir)/system.users
	$(verbose) $(M4) -D self_contained_policy $(M4PARAM) $^ | $(SED) -r -e 's/^[[:blank:]]+//' \
		-e '/^[[:blank:]]*($$|#)/d' >> $(tmpdir)/system.users
	$(verbose) $(INSTALL) -m 644 $(tmpdir)/system.users $@

$(userpath)/local.users: config/local.users
	@mkdir -p $(userpath)
	@echo "Installing local.users"
	$(verbose) $(INSTALL) -b -m 644 $< $@

########################################
#
# Appconfig files
#
install-appconfig: $(appfiles)

$(installdir)/booleans: $(booleans)
	@mkdir -p $(tmpdir)
	@mkdir -p $(installdir)
	$(verbose) $(SED) -r -e 's/false/0/g' -e 's/true/1/g' \
		-e '/^[[:blank:]]*($$|#)/d' $(booleans) | $(SORT) > $(tmpdir)/booleans
	$(verbose) $(INSTALL) -m 644 $(tmpdir)/booleans $@

$(contextpath)/files/media: $(appconf)/media
	@mkdir -p $(contextpath)/files/
	$(verbose) $(INSTALL) -m 644 $< $@

$(appdir)/default_contexts: $(appconf)/default_contexts
	@mkdir -p $(appdir)
	$(verbose) $(INSTALL) -m 644 $< $@

$(appdir)/removable_context: $(appconf)/removable_context
	@mkdir -p $(appdir)
	$(verbose) $(INSTALL) -m 644 $< $@

$(appdir)/default_type: $(appconf)/default_type
	@mkdir -p $(appdir)
	$(verbose) $(INSTALL) -m 644 $< $@

$(appdir)/userhelper_context: $(appconf)/userhelper_context
	@mkdir -p $(appdir)
	$(verbose) $(INSTALL) -m 644 $< $@

$(appdir)/initrc_context: $(appconf)/initrc_context
	@mkdir -p $(appdir)
	$(verbose) $(INSTALL) -m 644 $< $@

$(appdir)/failsafe_context: $(appconf)/failsafe_context
	@mkdir -p $(appdir)
	$(verbose) $(INSTALL) -m 644 $< $@

$(appdir)/dbus_contexts: $(appconf)/dbus_contexts
	@mkdir -p $(appdir)
	$(verbose) $(INSTALL) -m 644 $< $@

$(appdir)/users/root: $(appconf)/root_default_contexts
	@mkdir -p $(appdir)/users
	$(verbose) $(INSTALL) -m 644 $< $@

########################################
#
# Install policy headers
#
install-headers: $(tunxml) $(boolxml)
	@mkdir -p $(headerdir)
	@echo "Installing $(TYPE) policy headers."
	$(verbose) $(INSTALL) -m 644 $(tunxml) $(boolxml) $(headerdir)
	$(verbose) $(M4) $(M4PARAM) $(rolemap) > $(headerdir)/$(notdir $(rolemap))
	$(verbose) mkdir -p $(headerdir)/support
	$(verbose) $(INSTALL) -m 644 $(m4support) $(word $(words $(genxml)),$(genxml)) $(xmldtd) $(headerdir)/support
	$(verbose) $(genperm) $(avs) $(secclass) > $(headerdir)/support/all_perms.spt
	$(verbose) for i in $(notdir $(all_layers)); do \
		mkdir -p $(headerdir)/$$i ;\
		$(INSTALL) -m 644 $(moddir)/$$i/*.if \
			$(moddir)/$$i/metadata.xml \
			$(headerdir)/$$i ;\
	done
	$(verbose) echo "TYPE ?= $(TYPE)" > $(headerdir)/build.conf
	$(verbose) echo "NAME ?= $(NAME)" >> $(headerdir)/build.conf
ifneq "$(DISTRO)" ""
	$(verbose) echo "DISTRO ?= $(DISTRO)" >> $(headerdir)/build.conf
endif
	$(verbose) echo "MONOLITHIC ?= n" >> $(headerdir)/build.conf
	$(verbose) echo "DIRECT_INITRC ?= $(DIRECT_INITRC)" >> $(headerdir)/build.conf
	$(verbose) echo "POLY ?= $(POLY)" >> $(headerdir)/build.conf
	$(verbose) $(INSTALL) -m 644 $(support)/Makefile.devel $(headerdir)/Makefile

########################################
#
# Install policy documentation
#
install-docs: $(tmpdir)/html
	@mkdir -p $(docsdir)/html
	@echo "Installing policy documentation"
	$(verbose) $(INSTALL) -m 644 $(docfiles) $(docsdir)
	$(verbose) $(INSTALL) -m 644 $(wildcard $(htmldir)/*) $(docsdir)/html

########################################
#
# Install policy sources
#
install-src:
	rm -rf $(srcpath)/policy.old
	-mv $(srcpath)/policy $(srcpath)/policy.old
	mkdir -p $(srcpath)/policy
	cp -R . $(srcpath)/policy

########################################
#
# Generate tags file
#
tags: $(tags)
$(tags):
	@($(CTAGS) --version | grep -q Exuberant) || (echo ERROR: Need exuberant-ctags to function!; exit 1)
	@LC_ALL=C $(CTAGS) -f $(tags) --langdef=te --langmap=te:..te.if.spt \
	 --regex-te='/^type[ \t]+(\w+)(,|;)/\1/t,type/' \
	 --regex-te='/^typealias[ \t]+\w+[ \t+]+alias[ \t]+(\w+);/\1/t,type/' \
	 --regex-te='/^attribute[ \t]+(\w+);/\1/a,attribute/' \
	 --regex-te='/^[ \t]*define\(`(\w+)/\1/d,define/' \
	 --regex-te='/^[ \t]*interface\(`(\w+)/\1/i,interface/' \
	 --regex-te='/^[ \t]*bool[ \t]+(\w+)/\1/b,bool/' policy/modules/*/*.{if,te} policy/support/*.spt

########################################
#
# Filesystem labeling
#
checklabels:
	@echo "Checking labels on filesystem types: ext2 ext3 xfs jfs"
	@if test -z "$(filesystems)"; then \
		echo "No filesystems with extended attributes found!" ;\
		false ;\
	fi
	$(verbose) $(SETFILES) -v -n $(fcpath) $(filesystems)

restorelabels:
	@echo "Restoring labels on filesystem types: ext2 ext3 xfs jfs"
	@if test -z "$(filesystems)"; then \
		echo "No filesystems with extended attributes found!" ;\
		false ;\
	fi
	$(verbose) $(SETFILES) -v $(fcpath) $(filesystems)

relabel:
	@echo "Relabeling filesystem types: ext2 ext3 xfs jfs"
	@if test -z "$(filesystems)"; then \
		echo "No filesystems with extended attributes found!" ;\
		false ;\
	fi
	$(verbose) $(SETFILES) $(fcpath) $(filesystems)

resetlabels:
	@echo "Resetting labels on filesystem types: ext2 ext3 xfs jfs"
	@if test -z "$(filesystems)"; then \
		echo "No filesystems with extended attributes found!" ;\
		false ;\
	fi
	$(verbose) $(SETFILES) -F $(fcpath) $(filesystems)

########################################
#
# Clean everything
#
bare: clean
	rm -f $(polxml)
	rm -f $(tunxml)
	rm -f $(boolxml)
	rm -f $(mod_conf)
	rm -f $(booleans)
	rm -fR $(htmldir)
	rm -f $(tags)
# don't remove these files if we're given a local root
ifndef LOCAL_ROOT
	rm -f $(fcsort)
	rm -f $(support)/*.pyc
ifneq ($(generated_te),)
	rm -f $(generated_te)
endif
ifneq ($(generated_if),)
	rm -f $(generated_if)
endif
ifneq ($(generated_fc),)
	rm -f $(generated_fc)
endif
endif

.PHONY: install-src install-appconfig generate xml conf html bare tags
.SUFFIXES:
.SUFFIXES: .c