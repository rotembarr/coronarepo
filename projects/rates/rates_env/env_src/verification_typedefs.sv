`ifndef __VERIFICATION_TYPEDEFS
`define __VERIFICATION_TYPEDEFS

/*------------------------------------------------------------------------------
-- TypeDefs.
------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------
-- Monitor Item Type Declaration.
---------------------------------------------------------------------------------------*/
typedef avalon_st_monitor_item #(verification_pack::DATA_WIDTH_IN_BYTES) msg_in_item_type;
typedef avalon_st_monitor_item #(verification_pack::DATA_WIDTH_IN_BYTES) msg_out_item_type;

/*---------------------------------------------------------------------------------------
-- Sequence Item Type Declaration.
---------------------------------------------------------------------------------------*/
typedef avalon_st_sequence_item #(verification_pack::DATA_WIDTH_IN_BYTES) msg_in_sequence_item_type;

/*---------------------------------------------------------------------------------------
-- Sequencers Type Declaration.
---------------------------------------------------------------------------------------*/
typedef avalon_st_sequencer #(verification_pack::DATA_WIDTH_IN_BYTES) msg_in_sequencer_type;
typedef avalon_st_sequencer #(verification_pack::DATA_WIDTH_IN_BYTES) msg_out_sequencer_type;

/*---------------------------------------------------------------------------------------
-- Agents Type Declaration.
---------------------------------------------------------------------------------------*/
typedef avalon_st_agent #(verification_pack::DATA_WIDTH_IN_BYTES) msg_in_agent_type;
typedef avalon_st_agent #(verification_pack::DATA_WIDTH_IN_BYTES) msg_out_agent_type;

/*---------------------------------------------------------------------------------------
-- Scoreboard Type Declaration.
---------------------------------------------------------------------------------------*/
typedef general_scoreboard #(msg_out_item_type) msg_out_scoreboard_type;


`endif // __VERIFICATION_TYPEDEFS