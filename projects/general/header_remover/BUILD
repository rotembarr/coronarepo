load("@meru//:meru.bzl", "block", "testbench", "sim_test")
package(default_visibility=["//visibility:public"])

block(
    name = "header_remover",
    vlog_files = ["rtl/header_remover.sv"],
    blocks = ["//general/avalon_st_if:avalon_st_if"]
)

sim_test( #
	name = "tb",
	vlog_top = "tb/header_remover_tb.sv",
	top = "header_remover_tb",
	blocks = [":header_remover"]
)