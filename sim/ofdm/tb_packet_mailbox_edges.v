`timescale 1ns/1ps
// Standalone, self-checking mailbox regression. Compile with iverilog -g2012.
module tb_packet_mailbox_edges #(
    parameter real AXI_HALF_NS = 5.0,
    parameter real DATA_HALF_NS = 6.25,
    parameter real DATA_PHASE_NS = 1.7,
    parameter integer SAME_CLOCK = 0,
    parameter integer TIMEOUT_CYCLES = 8192
);
    reg axi_clk = 0, other_clk = 0;
    always #(AXI_HALF_NS) axi_clk = ~axi_clk;
    initial begin
        #(DATA_PHASE_NS);
        forever #(DATA_HALF_NS) other_clk = ~other_clk;
    end
    wire data_clk = SAME_CLOCK ? axi_clk : other_clk;
    reg resetn = 0, data_rst = 1;
    reg [7:0] awaddr = 0, araddr = 0;
    reg awvalid = 0, wvalid = 0, bready = 0, arvalid = 0, rready = 0;
    reg [31:0] wdata = 0;
    reg [3:0] wstrb = 0;
    wire awready, wready, bvalid, arready, rvalid;
    wire [1:0] bresp, rresp;
    wire [31:0] rdata;
    reg cmd_ready = 0, data_ready = 0, tx_done = 0;
    reg [1:0] tx_error = 0;
    reg rx_valid = 0, fcs_strobe = 0, fcs_ok = 0;
    reg [7:0] rx_byte = 0;
    reg [15:0] rx_length = 0;
    wire cmd_valid, data_valid, data_last;
    wire [10:0] cmd_length;
    wire [5:0] cmd_rate;
    wire [1:0] cmd_upsample;
    wire [7:0] data_byte;
    wire [2:0] led;
    reg [7:0] expected_tx [0:63];
    reg [7:0] expected_rx [0:63];
    integer seed = 1, seed_init, random_packets = 40, tests = 0;
    integer aw_count = 0, w_count = 0, b_count = 0, ar_count = 0, r_count = 0;
    integer command_count = 0, byte_count = 0;
    reg b_stalled = 0, r_stalled = 0;
    reg [1:0] held_bresp;
    reg [31:0] held_rdata;
    string selected = "all";

    ofdm_packet_mailbox
`ifdef MAILBOX_CONFIGURABLE_TIMEOUT
        #(.P_TIMEOUT_CYCLES(TIMEOUT_CYCLES))
`endif
        dut (
        .s_axi_aclk(axi_clk), .s_axi_aresetn(resetn),
        .s_axi_awaddr(awaddr), .s_axi_awvalid(awvalid), .s_axi_awready(awready),
        .s_axi_wdata(wdata), .s_axi_wstrb(wstrb), .s_axi_wvalid(wvalid),
        .s_axi_wready(wready), .s_axi_bresp(bresp), .s_axi_bvalid(bvalid),
        .s_axi_bready(bready), .s_axi_araddr(araddr), .s_axi_arvalid(arvalid),
        .s_axi_arready(arready), .s_axi_rdata(rdata), .s_axi_rresp(rresp),
        .s_axi_rvalid(rvalid), .s_axi_rready(rready),
        .data_clk(data_clk), .data_rst(data_rst),
        .cmd_ready(cmd_ready), .cmd_valid(cmd_valid), .cmd_length(cmd_length),
        .cmd_rate(cmd_rate), .cmd_upsample(cmd_upsample), .data_ready(data_ready),
        .data_valid(data_valid), .data_last(data_last), .data_byte(data_byte),
        .tx_done(tx_done), .tx_error(tx_error), .rx_valid(rx_valid), .rx_byte(rx_byte),
        .fcs_strobe(fcs_strobe), .fcs_ok(fcs_ok), .rx_length(rx_length), .status_led(led));

    // Each response must correspond to accepted traffic. Backpressure may not
    // change a response, even when another register or packet changes.
    always @(posedge axi_clk) begin
        if (!resetn) begin
            aw_count = 0; w_count = 0; b_count = 0; ar_count = 0; r_count = 0;
            b_stalled = 0; r_stalled = 0;
        end else begin
            if (b_stalled && (bvalid !== 1'b1 || bresp !== held_bresp))
                $fatal(1, "B response changed under backpressure");
            if (r_stalled && (rvalid !== 1'b1 || rdata !== held_rdata || rresp !== 0))
                $fatal(1, "R response changed under backpressure");
            if (awvalid && awready) aw_count = aw_count + 1;
            if (wvalid && wready) w_count = w_count + 1;
            if (bvalid && bready) b_count = b_count + 1;
            if (arvalid && arready) ar_count = ar_count + 1;
            if (rvalid && rready) r_count = r_count + 1;
            if (b_count > aw_count || b_count > w_count || r_count > ar_count)
                $fatal(1, "Unsolicited/duplicate AXI response");
            b_stalled = bvalid && !bready; held_bresp = bresp;
            r_stalled = rvalid && !rready; held_rdata = rdata;
        end
    end
    always @(posedge data_clk) begin
        if (data_rst) begin command_count = 0; byte_count = 0; end
        else begin
            if (cmd_valid && cmd_ready) command_count = command_count + 1;
            if (data_valid && data_ready) byte_count = byte_count + 1;
        end
    end

    function automatic integer choose(input integer limit);
        reg [31:0] number;
        begin number = $random(seed); choose = number % limit; end
    endfunction
    function automatic [31:0] tx_word(input integer index);
        tx_word = {expected_tx[index*4+3], expected_tx[index*4+2],
                   expected_tx[index*4+1], expected_tx[index*4]};
    endfunction
    function automatic [31:0] rx_word(input integer index);
        rx_word = {expected_rx[index*4+3], expected_rx[index*4+2],
                   expected_rx[index*4+1], expected_rx[index*4]};
    endfunction
    task automatic reset_all;
        integer j;
        begin
            @(negedge axi_clk); resetn = 0; data_rst = 1;
            awvalid = 0; wvalid = 0; bready = 0; arvalid = 0; rready = 0;
            cmd_ready = 0; data_ready = 0; tx_done = 0; tx_error = 0;
            rx_valid = 0; fcs_strobe = 0; fcs_ok = 0; rx_length = 0;
            for (j = 0; j < 64; j = j + 1) begin
                expected_tx[j] = 0; expected_rx[j] = 0;
            end
            // Both resets overlap, but deassert independently on local edges.
            fork
                begin repeat (24) @(negedge axi_clk); resetn = 1; end
                begin repeat (20) @(negedge data_clk); data_rst = 0; end
            join
            repeat (6) @(negedge axi_clk);
            if (bvalid !== 0 || rvalid !== 0 || led !== 0 || cmd_valid !== 0 || data_valid !== 0)
                $fatal(1, "Reset did not clear interface");
        end
    endtask

    task automatic axi_write(input [7:0] address, input [31:0] word,
                             input [3:0] strobes, input integer aw_delay,
                             input integer w_delay, input integer stall,
                             input [1:0] expected_resp);
        integer a, w, b, k;
        begin
            fork
                begin
                    repeat (aw_delay) @(negedge axi_clk);
                    @(negedge axi_clk); awaddr = address; awvalid = 1;
                    a = 0; @(posedge axi_clk);
                    while (!awready && a < 256) begin a = a + 1; @(posedge axi_clk); end
                    if (!awready) $fatal(1, "AW timeout addr=%h", address);
                    @(negedge axi_clk); awvalid = 0; awaddr = ~address;
                end
                begin
                    repeat (w_delay) @(negedge axi_clk);
                    @(negedge axi_clk); wdata = word; wstrb = strobes; wvalid = 1;
                    w = 0; @(posedge axi_clk);
                    while (!wready && w < 256) begin w = w + 1; @(posedge axi_clk); end
                    if (!wready) $fatal(1, "W timeout addr=%h", address);
                    @(negedge axi_clk); wvalid = 0; wdata = ~word; wstrb = ~strobes;
                end
                begin
                    bready = 0; b = 0;
                    @(negedge axi_clk);
                    while (!bvalid && b < 512) begin b = b + 1; @(negedge axi_clk); end
                    if (!bvalid) $fatal(1, "B timeout addr=%h", address);
                    if (bresp !== expected_resp)
                        $fatal(1, "BRESP addr=%h got=%h expected=%h", address, bresp, expected_resp);
                    for (k = 0; k < stall; k = k + 1) begin
                        @(negedge axi_clk);
                        if (!bvalid || bresp !== expected_resp) $fatal(1, "B hold failure");
                    end
                    bready = 1; @(negedge axi_clk); bready = 0;
                end
            join
        end
    endtask
    task automatic axi_read(input [7:0] address, input integer stall, output [31:0] word);
        integer a, k;
        begin
            @(negedge axi_clk); araddr = address; arvalid = 1; rready = 0;
            a = 0; @(posedge axi_clk);
            while (!arready && a < 256) begin a = a + 1; @(posedge axi_clk); end
            if (!arready) $fatal(1, "AR timeout addr=%h", address);
            @(negedge axi_clk); arvalid = 0; araddr = ~address;
            a = 0;
            while (!rvalid && a < 256) begin a = a + 1; @(negedge axi_clk); end
            if (!rvalid || rresp !== 0) $fatal(1, "R timeout/error addr=%h", address);
            word = rdata;
            for (k = 0; k < stall; k = k + 1) begin
                @(negedge axi_clk);
                if (!rvalid || rdata !== word || rresp !== 0) $fatal(1, "R hold failure");
            end
            rready = 1; @(negedge axi_clk); rready = 0;
        end
    endtask
    task automatic expect_read(input [7:0] address, input [31:0] wanted);
        reg [31:0] actual;
        begin
            axi_read(address, choose(5), actual);
            if (actual !== wanted) $fatal(1, "READ addr=%h got=%h expected=%h", address, actual, wanted);
        end
    endtask
    task automatic load_packet(input integer pattern);
        integer j;
        begin
            for (j = 0; j < 64; j = j + 1) begin
                case (pattern)
                    0: expected_tx[j] = 0;
                    1: expected_tx[j] = 255;
                    2: expected_tx[j] = j;
                    default: expected_tx[j] = choose(256);
                endcase
                expected_rx[j] = 0;
            end
            for (j = 0; j < 16; j = j + 1)
                axi_write(8'h40+4*j, tx_word(j), 15, choose(7), choose(7), choose(5), 0);
        end
    endtask
    task automatic start_packet;
        integer j, cycles;
        reg [31:0] status;
        begin
            for (j = 0; j < 64; j = j + 1) expected_rx[j] = 0;
            axi_write(0, 1, 1, choose(4), choose(4), choose(4), 0);
            axi_read(4, 0, status);
            if (status[1:0] !== 2'b01 || led !== 3'b001) $fatal(1, "Start busy/done/LED");
            expect_read(8'h80, 0);
            // AXI busy precedes the synchronized request in the data domain.
            // Observe COMMAND before injecting packet events or timing expiry.
            // cmd_ready stays low here: no command handshake is performed.
            cycles = 0;
            @(negedge data_clk);
            while (!cmd_valid && cycles < 256) begin
                @(negedge data_clk); cycles = cycles + 1;
            end
            if (!cmd_valid) $fatal(1, "Request never reached COMMAND");
        end
    endtask
    task automatic accept_command;
        integer n;
        begin
            n = 0; @(negedge data_clk);
            while (!cmd_valid && n < 256) begin n = n + 1; @(negedge data_clk); end
            if (!cmd_valid) $fatal(1, "Command missing");
            repeat (9) begin
                if (!cmd_valid || cmd_length !== 64 || cmd_rate !== 54 || cmd_upsample !== 0)
                    $fatal(1, "Command metadata/stall failure");
                @(negedge data_clk);
            end
            cmd_ready = 1; @(negedge data_clk); cmd_ready = 0;
        end
    endtask
    task automatic transmit(input integer number);
        integer j, k, delay_cycles;
        begin
            for (j = 0; j < number; j = j + 1) begin
                data_ready = 0; delay_cycles = choose(5);
                for (k = 0; k <= delay_cycles; k = k + 1) begin
                    @(negedge data_clk);
                    if (!data_valid || data_byte !== expected_tx[j] || data_last !== (j == 63))
                        $fatal(1, "TX stall/sequence failure byte=%0d got=%h expected=%h", j, data_byte, expected_tx[j]);
                end
                data_ready = 1; @(negedge data_clk); data_ready = 0;
            end
            if (number == 64 && data_valid) $fatal(1, "TX emitted more than 64 bytes");
        end
    endtask
    // collision=1: last RX byte and FCS together; 2: good TX done and FCS;
    // 3: TX error and FCS; 4: last RX byte, good TX done and FCS together.
    task automatic receive_packet(input integer number, input integer corrupt_index,
                                  input integer reported_length, input integer good_fcs,
                                  input integer collision);
        integer j;
        reg [7:0] sample;
        begin
            for (j = 0; j < number; j = j + 1) begin
                repeat (choose(4)) @(negedge data_clk);
                @(negedge data_clk);
                sample = expected_tx[j % 64] ^ ((j == corrupt_index) ? 8'h80 : 8'h00);
                rx_valid = 1; rx_byte = sample;
                if (j < 64) expected_rx[j] = sample;
                if ((collision == 1 || collision == 4) && j == number-1) begin
                    fcs_strobe = 1; fcs_ok = good_fcs; rx_length = reported_length;
                    tx_done = collision == 4;
                end
                @(negedge data_clk); rx_valid = 0; fcs_strobe = 0; tx_done = 0;
            end
            if (collision != 1 && collision != 4) begin
                @(negedge data_clk); fcs_strobe = 1; fcs_ok = good_fcs; rx_length = reported_length;
                tx_done = collision == 2 || collision == 3; tx_error = collision == 3 ? 2 : 0;
                @(negedge data_clk); fcs_strobe = 0; tx_done = 0; tx_error = 0;
            end
        end
    endtask
    task automatic check_result(input [4:0] flags, input integer length);
        integer n, j;
        reg [31:0] status;
        begin
            status = 0; n = 0;
            while (!status[1] && n < 256) begin axi_read(4, 0, status); n = n + 1; end
            if (status !== {25'd0, flags, 2'b10})
                $fatal(1, "RESULT got=%h expected flags=%h length=%0d", status, flags, length);
            if (led !== (flags[0] ? 3'b010 : 3'b100)) $fatal(1, "Result LED");
            expect_read(8, length);
            for (j = 0; j < 16; j = j + 1) expect_read(8'h80+4*j, rx_word(j));
            repeat (8) @(negedge axi_clk);
            expect_read(4, {25'd0, flags, 2'b10});
            if (cmd_valid || data_valid) $fatal(1, "Completion did not return idle");
            tests = tests + 1;
        end
    endtask
    task automatic good_packet;
        begin start_packet; accept_command; transmit(64); receive_packet(64, -1, 64, 1, 0); check_result(3, 64); end
    endtask

    task automatic test_axi;
        integer j, lane, mask;
        reg [31:0] word;
        begin
            $display("CASE AXI reset map / split AW-W / WSTRB / concurrent read-write");
            expect_read(4, 0); expect_read(8, 0);
            for (j = 0; j < 16; j = j + 1) begin
                expect_read(8'h40+4*j, 0); expect_read(8'h80+4*j, 0);
            end
            for (mask = 0; mask < 16; mask = mask + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    word = $random(seed);
                    axi_write(8'h40+4*j, word, mask, (j%3)*7, ((j+1)%3)*7, j%8, 0);
                    for (lane = 0; lane < 4; lane = lane + 1)
                        if ((mask >> lane) & 1) expected_tx[j*4+lane] = word[lane*8 +: 8];
                    expect_read(8'h40+4*j, tx_word(j));
                end
            end
            // Ignored control writes cannot start a transfer.
            axi_write(0, 1, 0, 12, 0, 5, 0);
            axi_write(0, 1, 14, 0, 12, 5, 0);
            axi_write(0, 2, 15, 0, 0, 0, 0);
            for (j = 0; j < 256; j = j + 4) begin
                if (j < 64 || j >= 128) begin
                    axi_write(j, 32'hfffffffe, 15, 0, 1, 2, 0);
                    expect_read(j, 0);
                end
            end
            // Read and write channels must not block each other.
            fork
                begin
                    for (j = 0; j < 16; j = j + 1)
                        axi_write(8'h40+4*j, tx_word(j), 15, 3, 0, 10, 0);
                end
                begin
                    repeat (32) expect_read(4, 0);
                end
            join
            good_packet;
        end
    endtask

    // Hold VALID continuously across successive requests, including when the
    // previous response is stalled. Independent AW/W streams preserve ordering.
    task automatic test_continuous;
        integer a, w, b, j, old_aw, old_w, old_b;
        reg [31:0] word;
        begin
            $display("CASE continuous VALID / outstanding response / response counts");
            old_aw = aw_count; old_w = w_count; old_b = b_count;
            fork
                begin
                    for (a = 0; a < 32; a = a + 1) begin
                        @(negedge axi_clk); awvalid = 1; awaddr = 8'h40+4*(a%16);
                        @(posedge axi_clk); while (!awready) @(posedge axi_clk);
                    end
                    @(negedge axi_clk); awvalid = 0;
                end
                begin
                    repeat (11) @(negedge axi_clk);
                    for (w = 0; w < 32; w = w + 1) begin
                        @(negedge axi_clk); wvalid = 1; wdata = 32'habc00000+w; wstrb = 15;
                        @(posedge axi_clk); while (!wready) @(posedge axi_clk);
                    end
                    @(negedge axi_clk); wvalid = 0;
                end
                begin
                    for (b = 0; b < 32; b = b + 1) begin
                        @(negedge axi_clk); while (!bvalid) @(negedge axi_clk);
                        if (bresp !== 0) $fatal(1, "Continuous write response");
                        repeat (7) @(negedge axi_clk);
                        bready = 1; @(negedge axi_clk); bready = 0;
                    end
                end
            join
            if (aw_count-old_aw != 32 || w_count-old_w != 32 || b_count-old_b != 32)
                $fatal(1, "Continuous transaction accounting");
            for (j = 0; j < 16; j = j + 1) begin
                word = 32'habc00010+j;
                {expected_tx[j*4+3], expected_tx[j*4+2], expected_tx[j*4+1], expected_tx[j*4]} = word;
                expect_read(8'h40+4*j, word);
            end
            // Continuous ARVALID must cause one response for each handshake.
            fork
                begin
                    for (a = 0; a < 24; a = a + 1) begin
                        @(negedge axi_clk); arvalid = 1; araddr = 8'h40+4*(a%16);
                        @(posedge axi_clk); while (!arready) @(posedge axi_clk);
                    end
                    @(negedge axi_clk); arvalid = 0;
                end
                begin
                    for (b = 0; b < 24; b = b + 1) begin
                        @(negedge axi_clk); while (!rvalid) @(negedge axi_clk);
                        if (rdata !== tx_word(b%16) || rresp !== 0) $fatal(1, "Continuous read");
                        repeat (5) @(negedge axi_clk);
                        rready = 1; @(negedge axi_clk); rready = 0;
                    end
                end
            join
            tests = tests + 1;
        end
    endtask

    task automatic test_busy;
        integer j, commands_before, bytes_before;
        reg [31:0] status;
        begin
            $display("CASE busy writes / immutable TX / hidden RX / stray events");
            load_packet(3); start_packet;
            commands_before = command_count; bytes_before = byte_count;
            axi_write(0, 1, 15, 0, 13, 6, 2);
            for (j = 0; j < 16; j = j + 1) begin
                axi_write(8'h40+4*j, ~tx_word(j), 15, 9, 0, 2, 2);
                expect_read(8'h40+4*j, tx_word(j));
                expect_read(8'h80+4*j, 0);
            end
            // A strobe in COMMAND is not a completion.
            @(negedge data_clk); fcs_strobe = 1; fcs_ok = 1; rx_length = 64;
            @(negedge data_clk); fcs_strobe = 0;
            accept_command;
            fork
                transmit(64);
                begin
                    axi_write(8'h40, 0, 15, 0, 5, 15, 2);
                    axi_write(0, 1, 1, 4, 0, 10, 2);
                end
            join
            // Normal TX done alone must leave mailbox waiting for RX.
            @(negedge data_clk); tx_done = 1;
            @(negedge data_clk); tx_done = 0;
            axi_read(4, 0, status);
            // Flags retain the previous snapshot until completion; only these
            // two bits describe the new in-flight transaction.
            if (status[1:0] !== 2'b01) $fatal(1, "TX done completed before RX");
            receive_packet(64, -1, 64, 1, 0); check_result(3, 64);
            if (command_count-commands_before != 1 || byte_count-bytes_before != 64)
                $fatal(1, "Busy write caused duplicate packet");
            @(negedge data_clk); rx_valid = 1; rx_byte = 0; fcs_strobe = 1; tx_done = 1; tx_error = 3;
            @(negedge data_clk); rx_valid = 0; fcs_strobe = 0; tx_done = 0; tx_error = 0;
            check_result(3, 64);
        end
    endtask

    task automatic test_collision(input integer collision, input integer corrupt);
        begin
            $display("CASE collision=%0d corrupt=%0d", collision, corrupt);
            load_packet(3); start_packet; accept_command; transmit(64);
            receive_packet(64, corrupt, 64, 1, collision);
            check_result(collision == 3 ? 8 : (corrupt < 0 ? 3 : 6), 64);
        end
    endtask

    task automatic test_timeout(input integer stage);
        integer cycles, before_commands;
        reg [31:0] status;
        begin
            $display("CASE timeout stage=%0d", stage);
            load_packet(2); start_packet;
            if (stage >= 1) accept_command;
            if (stage >= 2) transmit(64);
            if (stage == 1) transmit(13);
            if (stage == 3) begin
                // Partial receive: timeout returns only accepted bytes, padded.
                repeat (17) begin
                    @(negedge data_clk); rx_valid = 1; rx_byte = expected_tx[dut.rx_count];
                    expected_rx[dut.rx_count] = rx_byte;
                    @(negedge data_clk); rx_valid = 0;
                end
            end
            // Observe actual elapsed cycles (never force DUT timer/state).
            cycles = 0;
            while (dut.state != 0 && cycles < TIMEOUT_CYCLES+20) begin
                @(negedge data_clk); cycles = cycles + 1;
            end
            if (dut.state != 0) $fatal(1, "Timeout failed to terminate");
            check_result(16, stage == 3 ? 17 : 0);
            // No duplicate completion or phantom command after expiry.
            before_commands = command_count;
            repeat (12) @(negedge data_clk);
            if (command_count != before_commands) $fatal(1, "Timeout duplicate command");
            good_packet;
        end
    endtask

    task automatic test_deadline(input integer mode);
        integer j, count_before;
        begin
            $display("CASE exact timeout boundary mode=%0d", mode);
            load_packet(2); start_packet; accept_command; transmit(64);
            for (j = 0; j < 63; j = j + 1) begin
                @(negedge data_clk); rx_valid = 1; rx_byte = expected_tx[j];
                expected_rx[j] = rx_byte;
                @(negedge data_clk); rx_valid = 0;
            end
            // mode 0: FCS one cycle before expiry (success).
            // mode 1: FCS on expiry (timeout, last byte NOT captured).
            // mode 2: TX error on expiry (timeout has priority).
            // mode 3: corrupt last byte + TX error before expiry.
            while (dut.timeout_count < TIMEOUT_CYCLES - ((mode == 0 || mode == 3) ? 2 : 1))
                @(negedge data_clk);
            if (dut.state == 0) $fatal(1, "Premature timeout at deadline");
            count_before = dut.timeout_count;
            rx_valid = 1; rx_byte = expected_tx[63] ^ (mode == 3 ? 8'h80 : 8'h00);
            fcs_strobe = 1; fcs_ok = 1; rx_length = 64;
            tx_done = 1; tx_error = mode >= 2 ? 3 : 0;
            if (mode == 0 || mode == 3) expected_rx[63] = rx_byte;
            @(negedge data_clk); rx_valid = 0; fcs_strobe = 0; tx_done = 0; tx_error = 0;
            if (dut.state != 0) $fatal(1, "Missed terminal event count=%0d", count_before);
            check_result(mode == 0 ? 3 : (mode == 3 ? 12 : 16),
                         mode == 0 || mode == 3 ? 64 : 63);
        end
    endtask

    // Check the real elapsed deadline, rather than merely eventual termination.
    integer active_cycles = 0;
    always @(posedge data_clk) begin
        if (data_rst || dut.state == 0) active_cycles = 0;
        else begin
            active_cycles = active_cycles + 1;
            if (dut.timeout_count !== active_cycles - 1) $fatal(1, "Timer skipped a cycle");
            if (active_cycles == TIMEOUT_CYCLES) begin
                #0.001;
                if (dut.state !== 0 || dut.flags_d[4] !== 1)
                    $fatal(1, "Wrong exact timeout duration: %0d", active_cycles);
            end else if (active_cycles > TIMEOUT_CYCLES) $fatal(1, "Late timeout");
        end
    end

    task automatic test_reset(input integer stage);
        begin
            $display("CASE coordinated reset stage=%0d", stage);
            if (stage < 3) begin
                load_packet(3); start_packet;
                if (stage >= 1) accept_command;
                if (stage == 1) transmit(11);
                if (stage == 2) transmit(64);
            end else if (stage == 3) begin
                @(negedge axi_clk); awaddr = 8'h40; awvalid = 1;
                @(posedge axi_clk); while (!awready) @(posedge axi_clk);
                @(negedge axi_clk); awvalid = 0;
            end else if (stage == 4) begin
                @(negedge axi_clk); wdata = 32'hbadc0ffe; wstrb = 15; wvalid = 1;
                @(posedge axi_clk); while (!wready) @(posedge axi_clk);
                @(negedge axi_clk); wvalid = 0;
            end else begin
                @(negedge axi_clk); awvalid = 1; wvalid = 1; awaddr = 8'h40; wstrb = 15; wdata = 99;
                @(posedge axi_clk);
                if (!awready || !wready) $fatal(1, "Reset test initial handshake");
                @(negedge axi_clk); awvalid = 0; wvalid = 0; arvalid = 1; araddr = 8'h40;
                @(posedge axi_clk); if (!arready) $fatal(1, "Reset test read handshake");
                @(negedge axi_clk); arvalid = 0;
                repeat (5) @(negedge axi_clk);
                if (!rvalid || !bvalid) $fatal(1, "Missing pending responses before reset");
            end
            reset_all; expect_read(4, 0); expect_read(8'h40, 0); expect_read(8'h80, 0);
            load_packet(2); good_packet;
        end
    endtask

    task automatic test_errors;
        integer n, number, reported, corrupt, mode, collision;
        reg [4:0] flags;
        begin
            $display("CASE FCS / length / overflow / every corrupt byte / TX errors");
            for (n = 0; n < 10; n = n + 1) begin
                case (n)
                    0: number = 0; 1: number = 1; 2: number = 63; 3: number = 64;
                    4: number = 65; 5: number = 127; 6: number = 128;
                    7: number = 160; default: number = 64;
                endcase
                reported = n == 8 ? 0 : (n == 9 ? 65535 : number);
                load_packet(n%4); start_packet; accept_command; transmit(64);
                receive_packet(number, -1, reported, 1, n%2);
                check_result(number == 64 && reported == 64 ? 3 : 6, reported);
            end
            for (n = 0; n < 64; n = n + 1) begin
                load_packet(3); start_packet; accept_command; transmit(64);
                receive_packet(64, n, 64, 1, 1); check_result(6, 64);
            end
            load_packet(0); start_packet; accept_command; transmit(64);
            receive_packet(64, -1, 64, 0, 0); check_result(0, 64);
            load_packet(1); start_packet; accept_command; transmit(64);
            receive_packet(64, 63, 64, 0, 1); check_result(4, 64);
            for (n = 1; n < 4; n = n + 1) begin
                load_packet(3); start_packet;
                if (n >= 2) accept_command;
                if (n == 3) transmit(64);
                @(negedge data_clk); tx_done = 1; tx_error = n; rx_valid = 1; rx_byte = expected_tx[0] ^ 8'h80;
                expected_rx[0] = rx_byte;
                @(negedge data_clk); tx_done = 0; tx_error = 0; rx_valid = 0;
                check_result(12, 1);
            end
            for (n = 0; n < random_packets; n = n + 1) begin
                mode = choose(5); corrupt = mode == 1 ? choose(64) : -1;
                number = mode == 2 ? choose(100) : 64; reported = number;
                collision = 1 + 3*choose(2);
                flags = {2'b00, (corrupt >= 0 || number != 64), (mode != 3),
                         (corrupt < 0 && number == 64 && mode != 3)};
                load_packet(3); start_packet; accept_command; transmit(64);
                receive_packet(number, corrupt, reported, mode != 3, number == 0 ? 0 : collision);
                check_result(flags, reported);
            end
        end
    endtask

    task automatic test_snapshot;
        reg [31:0] held;
        integer j;
        begin
            $display("CASE snapshot isolation while response is stalled across restart");
            load_packet(3); good_packet;
            fork
                axi_read(8'h80, 80, held);
                begin
                    repeat (5) @(negedge axi_clk);
                    axi_write(0, 1, 1, 0, 0, 0, 0);
                end
            join
            if (held !== rx_word(0)) $fatal(1, "Snapshot overwritten on restart");
            expect_read(8'h80, 0);
            for (j = 0; j < 64; j = j + 1) expected_rx[j] = 0;
            accept_command; transmit(64); receive_packet(64, -1, 64, 1, 0); check_result(3, 64);
        end
    endtask

    integer t;
    initial begin
        if ($value$plusargs("SEED=%d", seed)) begin end
        seed_init = seed;
        if ($value$plusargs("RANDOM_PACKETS=%d", random_packets)) begin end
        if ($value$plusargs("CASE=%s", selected)) begin end
        $display("MAILBOX_CONFIG seed=%0d same=%0d axi_half=%0f data_half=%0f timeout=%0d case=%s",
                 seed_init, SAME_CLOCK, AXI_HALF_NS, DATA_HALF_NS, TIMEOUT_CYCLES, selected);
        reset_all;
        if (selected == "last_byte") test_collision(1, -1);
        else if (selected == "tx_fcs") test_collision(2, -1);
        else if (selected == "tx_error") test_errors;
        else if (selected == "timeout") test_timeout(0);
        else begin
            test_axi; test_continuous; test_busy;
            test_collision(1, -1); test_collision(1, 63);
            test_collision(2, -1); test_collision(3, -1); test_collision(4, -1);
            test_errors; test_snapshot;
            for (t = 0; t < 4; t = t + 1) test_timeout(t);
            for (t = 0; t < 4; t = t + 1) test_deadline(t);
            for (t = 0; t < 6; t = t + 1) test_reset(t);
        end
        repeat (10) @(negedge axi_clk);
        if (aw_count != w_count || aw_count != b_count || ar_count != r_count)
            $fatal(1, "Unfinished AXI transactions AW=%0d W=%0d B=%0d AR=%0d R=%0d",
                   aw_count, w_count, b_count, ar_count, r_count);
        $display("MAILBOX_EDGES_PASS cases=%0d seed=%0d", tests, seed_init);
        $finish;
    end
    initial begin
        #(DATA_HALF_NS * (TIMEOUT_CYCLES * 12.0 + 20000000.0));
        $fatal(1, "Global mailbox regression watchdog");
    end
endmodule