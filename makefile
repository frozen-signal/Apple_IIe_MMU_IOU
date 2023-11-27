COMPILER=ghdl
GHDL_FLAGS= --workdir=work
FILES_FLAG= -Wno-binding

COMMON_FILES := $(shell find ./COMMON -print -type d | grep \.vhdl$$)
CUSTOM_FILES := $(shell find ./CUSTOM -print -type d | grep -v VENDOR | grep -v SIM | grep \.vhdl$$)
TTL_FILES := $(shell find ./TTL -print -type d | grep \.vhdl$$)
MMU_FILES := $(shell find ./MMU -print -type d | grep \.vhdl$$)
IOU_FILES := $(shell find ./IOU -print -type d | grep \.vhdl$$)
ifdef VENDOR
VENDOR_FILES := $(shell find ./CUSTOM -print -type d | grep VENDOR | grep $(VENDOR) | grep \.vhdl$$)
endif
SIM_FILES := $(shell find ./CUSTOM -print -type d | grep SIM | grep \.vhdl$$)

TEST_FILES := $(shell find ./test -print -type d | grep \.vhdl$$)

ALL_ENTITIES = $(shell $(COMPILER) --dir $(GHDL_FLAGS) | grep -e ^entity -e ^configuration | grep -v _entity | sed -e "s/entity //g"  | sed -e "s/configuration //g")
TEST_ENTITIES = $(shell $(COMPILER) --dir $(GHDL_FLAGS) | grep -e ^entity -e ^configuration | grep -v _entity | grep _tb | sed -e "s/entity //g"  | sed -e "s/configuration //g")

define make-entity
	@echo Making $(1)
	@$(COMPILER) -m $(GHDL_FLAGS) $(1)

endef

define run-test
	@$(COMPILER) -r $(GHDL_FLAGS) $(1)

endef

.PHONY: clean import files build test

clean :
	rm -f work/*

import :
		@$(COMPILER) -i $(GHDL_FLAGS) $(COMMON_FILES)
		@$(COMPILER) -i $(GHDL_FLAGS) $(CUSTOM_FILES)
		@$(COMPILER) -i $(GHDL_FLAGS) $(TTL_FILES)

		@$(COMPILER) -i $(GHDL_FLAGS) $(MMU_FILES)
		@$(COMPILER) -i $(GHDL_FLAGS) $(IOU_FILES)
ifdef VENDOR
		@$(COMPILER) -i $(GHDL_FLAGS) $(VENDOR_FILES)
else
		@$(COMPILER) -i $(GHDL_FLAGS) $(SIM_FILES)
endif
		@$(COMPILER) -i $(GHDL_FLAGS) $(TEST_FILES)

files :
		@$(COMPILER) --elab-order $(GHDL_FLAGS) $(FILES_FLAG) $(ASIC)

build :
		$(foreach ENTITY, $(ALL_ENTITIES), $(call make-entity, $(ENTITY)))

test :
		$(foreach TEST_ENTITY, $(TEST_ENTITIES), $(call run-test, $(TEST_ENTITY)))
