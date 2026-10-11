# Locate this project from the script, independently of the caller working directory.
set fpga_project_root [file normalize [file join [file dirname [info script]] ..]]
# A disposable experiment: test documented net collection form without routing.
set project_dir ${fpga_project_root}/src/td_project
set input_db ${fpga_project_root}/build/manual/AC201_tf_hdmi_place.db
set output_dir ${fpga_project_root}/build/attempt_packet_hfn_collection
file mkdir $output_dir
cd $project_dir
if {[catch {
    import_device eagle_s20.db -package EG4S20BG256
    open_project AC201_tf_hdmi.al -single_run -noanalyze
    load_run_param -run phy_1
    import_db $input_db
    set target_nets [get_nets -hier -full_hier {u_frame_buffer/u_sdram/u2_ram/u2_wrrd/sdr_t}]
    puts "TARGET_COLLECTION: $target_nets"
    phys_opt -force_replication_on_nets $target_nets -fanout_threshold 16 -effort low
    report_nets [get_nets -hier -full_hier {*sdr_t*}] -connection -hierarchy
    export_db $output_dir/AC201_tf_hdmi_hfn.db
} message]} {
    puts "HFN_COLLECTION_ERROR: $message"
    exit 1
}
puts HFN_COLLECTION_COMPLETE
exit
