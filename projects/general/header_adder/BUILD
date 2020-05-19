load("@meru//:meru.bzl", "block", "testbench", "sim_test")
package(default_visibility=["//visibility:public"])

block(
    name = "header_adder",
    vlog_files = ["rtl/header_adder.sv"],
    blocks = ["//general/avalon_st_if:avalon_st_if"]
)

sim_test( #
	name = "tb",
	vlog_top = "tb/header_adder_tb.sv",
	top = "header_adder_tb",
	blocks = [":header_adder"]
)