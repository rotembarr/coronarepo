load("@meru//:meru.bzl", "block", "sim_test", "regression_test")
package(default_visibility=["//visibility:public"])

sim_test(
    name = "test",
    top = "top_tb",
    vlog_top = "top_tb.sv",
    blocks = [":env"],
    defines = {
        "SHIT": "",
        "BUS_WIDTH": "128"
    }
)

regression_test(
    name = "full_test",
    vlog_top = "top_tb.sv",
    top = "top_tb",
    blocks = [":env"],
    defines = {
        "PROJECT" : ["VALUE", "SHIT", None],
        "ANOTHER" : ["NAME", "DAMN"],
        "BUS_WIDTH" : ["128"],
    }
)

block(
    name = "env",
    vlog_files = [
        "verification_pack.sv",
        "generation_parameters.sv",
        "msg_sequence.sv",
        "verification_typedefs.sv",
        "coverage.sv",
        "reference_model.sv",
        "virtual_sequencer.sv",
        "virtual_sequence.sv",
        "environment.sv",
        "base_test.sv",
    ],
    blocks = [
        "//avalon_st:avalon_st_if",
        "//avalon_st:avalon_st",
        "//general_scoreboard:general_scoreboard",
    ]
)
