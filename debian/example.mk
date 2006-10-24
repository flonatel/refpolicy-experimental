# installation paths

AWK ?= gawk
NAME ?= $(strip $(shell $(AWK) -F= '/^SELINUXTYPE/{ print $$2 }' /etc/selinux/config))

MLSENABLED := $(shell cat /selinux/mls)
ifeq ($(MLSENABLED),)
	MLSENABLED := 1
endif

ifeq ($(MLSENABLED),1)
	MCSFLAG=-mcs
endif

ifeq ($(NAME), mls)
	NAME = strict
	MCSFLAG = -mls
endif

TYPE ?= $(NAME)${MCSFLAG}

HEADERDIR := /path/to/where/selinux-policy-refpolicy-src/tarball/was/unpacked
include $(HEADERDIR)/Makefile

# arch-tag: 56a0db1b-e624-4696-9882-9b7147b719f9
