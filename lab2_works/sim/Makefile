###############################################################################
#                                                                             #
#                 Simulation Harness for EE180 MIPS (Lab 2)                   #
#                                                                             #
# This Makefile implements the testing infrastructure for the EE180 Lab2      #
# pipeline MIPS processor design. It builds a simulation executable and       #
# runs it with a set of assembly program tests which are automatically        #
# discovered and compiled.                                                    #
#                                                                             #
# Typical Usage:                                                              #
#   make             : Compile outdated test programs and run all tests.      #
#   make test        : Same as 'make'.                                        #
#   make test_<foo>  : Compile and test only <foo>.                           #
#   make wave_<foo>  : View the waveform for test <foo>.                      #
#   make clean       : Delete files which were generated by this Makefile.    #
#                                                                             #
# Requirements:                                                               #
#   - iverilog                                                                #
#   - gtkwave                                                                 #
#                                                                             #
###############################################################################


#---------- Basic settings ----------#
SHELL             := /bin/bash
TESTBENCH         := harness/userlogic_test.v
BLD_ROOT          := build
HDL_ROOT          := ../hw/hdl/verilog
HDL_EXTS          := .v
TST_ROOT          := tests
TST_MAKEFILE      := harness/Makefile_MIPS
TST_LSCRIPT       := harness/mips.ls
TST_REPORTER      := harness/results.py
WAV_CONFIG        := harness/waveformat.gtkw
TST_WAVEDUMP      := streamwave.vcd
TST_CONFIG_NAME   := test.conf
TST_TOOLCHAIN     := /afs/ir.stanford.edu/class/ee180/mips_tc
TST_UTIL          := /afs/ir.stanford.edu/class/ee180/util
TST_IBUF_NAME     := ibuf.hex
TST_OBUF_NAME     := obuf.hex
TST_OBUF_GEN_NAME := obuf_test.hex
TST_RESULT_FILE   := test.result
TST_SUMMARY_FILE  := $(BLD_ROOT)/latest_test_results


#---------- No need to modify below ----------#
HDL_DIRS    := $(shell find $(HDL_ROOT) -type d -print)
HDL_SRCS    := $(foreach DIR,$(HDL_DIRS),$(foreach EXT,$(HDL_EXTS),$(wildcard $(DIR)/*$(EXT))))
SIM_EXE     := $(BLD_ROOT)/$(basename $(notdir $(TESTBENCH)))
TST_DIRS    := $(shell find $(TST_ROOT) -mindepth 1 -maxdepth 1 -type d -print)
TST_SRCBASE := .
TST_BLDBASE := build
TST_APPNAME := app
TST_IMGS    := $(addsuffix /$(TST_BLDBASE)/$(TST_APPNAME).hex,$(TST_DIRS))
TST_IMGS_UPDATE := $(addsuffix _update,$(TST_IMGS))
TST_NAMES   := $(addprefix test_,$(notdir $(TST_DIRS)))
TST_RESULTS := $(addsuffix /$(TST_RESULT_FILE),$(TST_DIRS))
WAV_NAMES   := $(addprefix wave_,$(notdir $(TST_DIRS)))
WAV_DUMPS   := $(addsuffix /$(TST_WAVEDUMP),$(TST_DIRS))
REPORTALL   := 0

.PHONY: all check_xilinx build_tests test report_all test_reset $(TST_NAMES) $(TST_IMGS_UPDATE) $(WAV_NAMES) clean

all: test


check_xilinx:
ifneq (,$(findstring Xilinx,$(LD_LIBRARY_PATH)))
	@echo "WARNING: Xilinx tools may have clobbered the environment variable 'LD_LIBRARY_PATH'" \
     "and may prevent compilation. Unset or revert it to fix the issue."
endif


$(BLD_ROOT):
	@mkdir -p $@


$(SIM_EXE): $(TESTBENCH) $(HDL_SRCS) | $(BLD_ROOT) check_xilinx
	@echo '[SIM EXE] $@'
	@iverilog -o $(SIM_EXE) $(addprefix -y,$(HDL_DIRS)) $(addprefix -I,$(HDL_DIRS)) $(TESTBENCH)


build_tests: $(TST_IMGS)


$(TST_IMGS_UPDATE): %_update:
	@$(MAKE) -s -f $(abspath $(TST_MAKEFILE)) -C $(patsubst %/build/app.hex,%,$*) \
     LD_SCRIPT=$(abspath $(TST_LSCRIPT)) MIPS_BASE=$(abspath $(TST_TOOLCHAIN)) \
     UTIL_BASE=$(abspath $(TST_UTIL)) PROGRAM_NAME=$(TST_APPNAME) SOURCE_BASE=$(TST_SRCBASE) \
     BUILD_BASE=$(TST_BLDBASE)


.SECONDEXPANSION:
$(TST_IMGS): $$@_update | check_xilinx ;


test: REPORTALL=1
test: test_reset $(TST_NAMES)
	@$(TST_REPORTER) -r $(TST_SUMMARY_FILE)


test_reset:
	@rm -f $(TST_SUMMARY_FILE)


# Given a test name, return the test output file name
test_result = $(filter %$(1)/$(TST_RESULT_FILE),$(TST_RESULTS))


# Given a test name, return the wave dump file name
test_dumpwave = $(filter %$(1),$(TST_DIRS))/$(TST_WAVEDUMP)


# Given a test name, return the path of its working directory name
test_dir = $(filter %/$(1),$(TST_DIRS))


# Given a test result file name, return the test's compilation output
test_img = $(dir $(1))$(TST_BLDBASE)/$(TST_APPNAME).hex


# Given a test result file name, return the name of the test's input buffer
test_ibuf = $(wildcard $(dir $(1))$(TST_IBUF_NAME))


# Given a test result file name, return the name of the test's output reference buffer
test_obuf_ref = $(wildcard $(dir $(1))$(TST_OBUF_NAME))


# Given a test result file name, return the name of the test's output generated buffer
test_obuf_gen = $(dir $(1))$(TST_OBUF_GEN_NAME)


$(TST_NAMES): test_%: $$(call test_result,$$*) | check_xilinx
	@if [ '$(REPORTALL)' -eq '0' ]; then rm -f $(TST_SUMMARY_FILE); fi
	@printf '$* %s\n' $$(cat $(call test_dir,$*)/test.result) >> $(TST_SUMMARY_FILE)
	@if [ '$(REPORTALL)' -eq '0' ]; then $(TST_REPORTER) -r $(TST_SUMMARY_FILE); fi


$(TST_RESULTS): $(SIM_EXE) $$(dir $$@)$(TST_CONFIG_NAME) $$(call test_img,$$@) $$(call test_ibuf,$$@) $$(call test_obuf,$$@)
	@echo '[Test]    $@'
	@$(SIM_EXE) +instr_mem=$(call test_img,$@) \
     $(shell cat $(dir $@)$(TST_CONFIG_NAME)) \
     $(if $(call test_ibuf,$@),+in_buf=$(call test_ibuf,$@)) \
     $(if $(call test_obuf_ref,$@),+out_buf=$(call test_obuf_gen,$@),+test_result=$@ +dumpvars=$(dir $@)$(TST_WAVEDUMP)) \
     <<< "finish" > $(dir $@)sim.log 2>&1
	@$(if $(call test_obuf_ref,$@),! cmp -s $(call test_obuf_ref,$@) $(call test_obuf_gen,$@); echo $$? > $@)


$(WAV_DUMPS): %/$(TST_WAVEDUMP) : $$*/$(TST_RESULT_FILE)


$(WAV_NAMES): wave_%: $$(call test_dumpwave,$$*) | check_xilinx
	@echo '[Wave]     $@'
	gtkwave -f $(call test_dir,$*)/$(TST_WAVEDUMP) $(WAV_CONFIG)


clean:
	@for d in $(TST_DIRS); do (cd $$d && $(MAKE) -s -f $(abspath $(TST_MAKEFILE)) clean; \
     rm -f test.result; rm -f $(TST_WAVEDUMP); rm -f sim.log; rm -f $(TST_OBUF_GEN_NAME) ); done
ifeq ($(HDL_ROOT),$(BLD_ROOT))
	@echo "clean: Source and build directories are the same: not deleting."
else
	@rm -rf $(BLD_ROOT)
endif
	@echo Cleanup done.

