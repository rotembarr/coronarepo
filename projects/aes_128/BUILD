load("@meru//:meru.bzl", "block")
package(default_visibility=["//visibility:public"])

block(
    name = "aes_128",
    vlog_files = [
    	"rtl/aes_model_pack.sv",
    	"rtl/sub_bytes.sv",
    	"rtl/shift_rows.sv",
    	"rtl/mix_one_column_byte.sv",
    	"rtl/mix_one_column.sv",
    	"rtl/mix_columns.sv",
    	"rtl/key_warm.sv",
    	"rtl/round_cipher.sv",
    	"rtl/key_and_sync_control.sv",
    	"rtl/encryptor.sv",
    	"rtl/data_flow_control.sv",
    	"rtl/aes_block.sv",
    	"rtl/aes_counter_mode.sv"
    ]
)