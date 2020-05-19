load("@meru//:meru.bzl", "block", "testbench", "sim_test")
package(default_visibility=["//visibility:public"])

block(
    name = "msg_dropper",
    vlog_files = [
        "rtl/msg_dropper.sv"
    ],
    blocks = [
    	"//general/avalon_st_if:avalon_st_if"
    ]
)

sim_test(
	name = "tb",
	vlog_top = "tb/msg_dropper_tb.sv",
	top = "msg_dropper_tb",
	blocks = [
		":msg_dropper"
	]
)