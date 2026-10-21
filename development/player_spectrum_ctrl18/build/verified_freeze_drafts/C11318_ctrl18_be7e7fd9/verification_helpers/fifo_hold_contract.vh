// Observe the actual production FIFO used by the reduced RGB reservoir.
integer held_fifo_cycles=0, held_fifo_high_cycles=0;
reg [31:0] held_fifo_before;
reg held_fifo_check;
always @(posedge dut.u_frame_buffer.read_clk) begin
    held_fifo_before=dut.u_frame_buffer.read_word;
    held_fifo_check=!dut.u_frame_buffer.rst &&
        !dut.u_frame_buffer.read_fifo_clear && !dut.u_frame_buffer.read_word_pop;
    #1;
    if (held_fifo_check && !dut.u_frame_buffer.rst &&
        !dut.u_frame_buffer.read_fifo_clear && (^held_fifo_before !== 1'bx)) begin
        if(dut.u_frame_buffer.read_word !== held_fifo_before)
            $fatal(1,"Actual normal FIFO changed held output without read enable");
        held_fifo_cycles=held_fifo_cycles+1;
        if(dut.u_frame_buffer.u_unpack.byte_count>4)
            held_fifo_high_cycles=held_fifo_high_cycles+1;
    end
end
task check_fifo_hold_contract;
begin
    if(held_fifo_cycles<1000 || held_fifo_high_cycles<1000)
        $fatal(1,"FIFO hold contract lacks live suffix coverage");
    $display("FIFO_HOLD_CONTRACT_PASS held=%0d live_high=%0d",held_fifo_cycles,held_fifo_high_cycles);
end
endtask
