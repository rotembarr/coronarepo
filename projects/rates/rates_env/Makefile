
# Parameters
ROOT_PATH=/sec_storage/general/verification/empty_env
VLOG_PATH=$(ROOT_PATH)/vlog_files.txt
LOGS_FOLDER_NAME=Logs
SIMV_PATH=${LOGS_FOLDER_NAME}/simv
TEST_NAME=base_test
TOP_TB_NAME=top_tb
LOGS_DIR_PATH=$(ROOT_PATH)/$(LOGS_FOLDER_NAME)

# Commands
VERILOG_ANALYZE_COMMAND=$(VCS_HOME)/bin/vlogan -sverilog -full64 -work WORK +incdir+$(UVM_HOME)/src $(UVM_HOME)/uvm_pkg.sv -ntb_opts uvm

ELABORATION_CMD=$(VCS_HOME)/bin/vcs -full64 -timescale=1ns/1ns -CFLAGS -DVCS -debug_access+all \
$(UVM_HOME)/dpi/uvm_dpi.cc -j1 ${TOP_TB_NAME} -l ${LOGS_FOLDER_NAME}/elaboration.log -o ${SIMV_PATH}

SIMULATION_CMD=${SIMV_PATH} +UVM_VERBOSITY=UVM_MEDIUM +UVM_TESTNAME=${TEST_NAME} -l ${LOGS_FOLDER_NAME}/${TEST_NAME}.log \
 +ntb_random_reseed +ntb_random_seed=1


analyze:
	${VERILOG_ANALYZE_COMMAND} -f ${VLOG_PATH}

elaboration: analyze
	[ -d $(LOGS_DIR_PATH) ] || mkdir -p $(LOGS_DIR_PATH)
	${ELABORATION_CMD}

sim: elaboration
	${SIMULATION_CMD}

gui: elaboration
	$(SIMULATION_CMD) -gui

clean: 
	rm AN.DB/ csrc/ Logs/ ucli.key vc_hdrs.h verilog.dump *inter* dump* -rf
