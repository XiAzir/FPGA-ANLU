# Disabled historical candidate. Do not execute: phase9/data0/setup2-only is
# the active candidate; this TOFF experiment is excluded from the delivery set.
error "PAD_PROBE_DISABLED: historical TOFF experiment; not in current candidate or delivery manifest"

# PAD_PROBE_CAPTURE_EDGE=falling enables a separate DQ input capture experiment.

set script_dir [file dirname [file normalize [info script]]]
set repo_root [file normalize [file join $script_dir .. .. .. ..]]
set project_root [file join $repo_root development player_video42_sdram100]
set project_dir [file join $project_root src td_project]
set input_db [file join $project_root build manual AC201_tf_hdmi_gate.db]

if {[info exists ::env(PAD_PROBE_CAPTURE_EDGE)]} {
    set capture_edge $::env(PAD_PROBE_CAPTURE_EDGE)
} else {
    set capture_edge rising
}
if {$capture_edge ni {rising falling}} {
    error "PAD_PROBE_CAPTURE_EDGE must be rising or falling"
}

set output_dir [file join $script_dir $capture_edge]
file mkdir $output_dir

# These are the 32 DQ PAD instance names resolved from the unmodified C42 gate netlist.
set dq_pad_instances {
    sdram_syn_1 sdram_syn_2 sdram_syn_3 sdram_syn_7
    sdram_syn_18 sdram_syn_19 sdram_syn_20 sdram_syn_21
    sdram_syn_22 sdram_syn_23 sdram_syn_24 sdram_syn_25
    sdram_syn_26 sdram_syn_27 sdram_syn_28 sdram_syn_29
    sdram_syn_30 sdram_syn_31 sdram_syn_32 sdram_syn_33
    sdram_syn_34 sdram_syn_35 sdram_syn_43 sdram_syn_47
    sdram_syn_48 sdram_syn_49 sdram_syn_50 sdram_syn_51
    sdram_syn_52 sdram_syn_53 sdram_syn_54 sdram_syn_55
}

set model_name top
set oe_d_nets [get_nets -hier -regexp {.*u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t_reg_syn_5$}]
if {[llength $oe_d_nets] != 1} {
    error "Expected one sdr_t_reg D net, found [llength $oe_d_nets]: $oe_d_nets"
}
set oe_d_net [lindex $oe_d_nets 0]

cd $project_dir
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $input_db

    # Preserve the original OE FF for its internal feedback logic. Move the
    # PAD ts inputs to that FF's D net; each PAD TO FF then captures the same
    # value on the same mem_clk edge without adding a cycle of protocol delay.
    foreach pad $dq_pad_instances {
        set inst "u_frame_buffer/u_sdram/$pad"
        set_inst_attr -model_name $model_name -inst $inst -attr_key TO_DFFMODE -attr_value FF
        set_inst_attr -model_name $model_name -inst $inst -attr_key TO_REGSET -attr_value RESET
        if {$capture_edge eq "falling"} {
            set_inst_attr -model_name $model_name -inst $inst -attr_key INPCLKMUX -attr_value INV
        }
        disconnect_inst_pin -model_name $model_name -inst $inst -pin ts
        connect_inst_pin -model $model_name -inst $inst -pin ts -net $oe_d_net
    }

    # Save the in-memory candidate before physical operations. Input gate DB is
    # imported read-only and all outputs are isolated under this script folder.
    write_verilog [file join $output_dir AC201_tf_hdmi_gate_candidate.v]
    export_db [file join $output_dir AC201_tf_hdmi_gate_candidate.db]

    set_param place effort high
    set_param place opt_timing high
    set_param place crit_path_opt on
    set_param place post_place_opt high
    set_param place hfn_opt_effort high
    set_param route effort routability
    set_param gate pack_effort high
    commit_param -step place
    place
    update_timing -mode manhattan
    report_timing_status -file [file join $output_dir place.ts]
    export_db [file join $output_dir place.db]
    commit_param -step route
    route
    update_timing -mode final
    report_timing_status -file [file join $output_dir physical.ts]
    report_timing_summary -file [file join $output_dir physical.timing]
    check_timing -verbose -file [file join $output_dir check.timing]
    report_timing_exception -file [file join $output_dir exceptions.timing]
    report_area -io_info -file [file join $output_dir physical.area]
    write_verilog [file join $output_dir AC201_tf_hdmi_pr_candidate.v] -implement
    export_db [file join $output_dir AC201_tf_hdmi_pr_candidate.db]
} message]} {
    puts "PAD_PROBE_ERROR: $message"
    close_project
    exit 1
}

puts "PAD_PROBE_COMPLETE: capture_edge=$capture_edge output_dir=$output_dir"
close_project
exit
