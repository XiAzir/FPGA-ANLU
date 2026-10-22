module tb;
    reg clk=0, rst=1, start=0, next_frame=0;
    reg [7:0] card_data=0;
    reg card_valid=0, card_end=0, file_error=0, jpeg_accept=0;
    wire card_read_a, card_read_b, file_ready_a, file_ready_b;
    wire [31:0] card_addr_a, card_addr_b, frame_length_a, frame_length_b;
    wire [8:0] last_index_a, last_index_b, frame_index_a, frame_index_b, sequence_index_a, sequence_index_b;
    wire frame_ready_a, frame_ready_b, jpeg_valid_a, jpeg_valid_b, jpeg_last_a, jpeg_last_b;
    wire [31:0] jpeg_data_a, jpeg_data_b;
    wire [3:0] jpeg_strb_a, jpeg_strb_b;
    wire frame_sent_a, frame_sent_b, busy_a, busy_b, error_a, error_b;
    integer cycle, compared=0;

    always #5 clk = ~clk;
    mjp_file_reader_reference ref_dut(
        .clk(clk),.rst(rst),.start(start),.next_frame(next_frame),
        .card_read(card_read_a),.card_addr(card_addr_a),.card_data(card_data),
        .card_valid(card_valid),.card_end(card_end),.file_error(file_error),
        .file_ready(file_ready_a),.last_index(last_index_a),.frame_ready(frame_ready_a),
        .frame_index(frame_index_a),.frame_length(frame_length_a),.jpeg_valid(jpeg_valid_a),
        .jpeg_data(jpeg_data_a),.jpeg_strb(jpeg_strb_a),.jpeg_last(jpeg_last_a),
        .jpeg_accept(jpeg_accept),.frame_sent(frame_sent_a),.sequence_index(sequence_index_a),
        .busy(busy_a),.error(error_a));
    mjp_file_reader dut(
        .clk(clk),.rst(rst),.start(start),.next_frame(next_frame),
        .card_read(card_read_b),.card_addr(card_addr_b),.card_data(card_data),
        .card_valid(card_valid),.card_end(card_end),.file_error(file_error),
        .file_ready(file_ready_b),.last_index(last_index_b),.frame_ready(frame_ready_b),
        .frame_index(frame_index_b),.frame_length(frame_length_b),.jpeg_valid(jpeg_valid_b),
        .jpeg_data(jpeg_data_b),.jpeg_strb(jpeg_strb_b),.jpeg_last(jpeg_last_b),
        .jpeg_accept(jpeg_accept),.frame_sent(frame_sent_b),.sequence_index(sequence_index_b),
        .busy(busy_b),.error(error_b));

    task compare;
    begin
        #1;
        if ({card_read_a,card_addr_a,file_ready_a,last_index_a,frame_ready_a,frame_index_a,
             frame_length_a,jpeg_valid_a,jpeg_data_a,jpeg_strb_a,jpeg_last_a,frame_sent_a,
             sequence_index_a,busy_a,error_a} !==
            {card_read_b,card_addr_b,file_ready_b,last_index_b,frame_ready_b,frame_index_b,
             frame_length_b,jpeg_valid_b,jpeg_data_b,jpeg_strb_b,jpeg_last_b,frame_sent_b,
             sequence_index_b,busy_b,error_b}) begin
            $display("DIFF cycle=%0d", cycle);
            $fatal(1,"reader outputs differ");
        end
        compared=compared+1;
    end
    endtask

    initial begin
        repeat (3) begin @(negedge clk); compare(); end
        rst=0;
        for (cycle=0; cycle<40000; cycle=cycle+1) begin
            @(negedge clk);
            card_data = $random;
            card_valid = (($random & 3) != 0);
            card_end = (($random & 31) == 0);
            file_error = (($random & 255) == 0);
            start = (($random & 63) == 0);
            next_frame = (($random & 15) == 0);
            jpeg_accept = (($random & 3) != 0);
            if ((cycle % 997)==0) rst=1;
            else if ((cycle % 997)==2) rst=0;
            compare();
        end
        $display("READER_DIFF_PASS cycles=%0d comparisons=%0d",cycle,compared);
        $finish;
    end
endmodule
