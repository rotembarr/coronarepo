load("@meru//:meru.bzl", "block")
package(default_visibility=["//visibility:public"])

block(
    name = "avalon_st_if",
    vlog_files = [
        "generic_func_pack.sv",
        "avalon_st_if.sv"
    ],
)

block(
    name = "avalon_st",
    vlog_files = [
        "avalon_st_sequence_item.sv",
        "avalon_st_monitor_item.sv",
        "avalon_st_sequencer.sv",
        "avalon_st_configuration.sv",
        "avalon_st_driver.sv",
        "avalon_st_monitor.sv",
        "avalon_st_agent.sv",
    ],
    blocks = [":avalon_st_if"]
)