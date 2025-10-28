`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// fir_synth.v  -- FIR filter with sample counter (synthesizable)
//////////////////////////////////////////////////////////////////////////////////
module fir_synth #(
    parameter integer TAP    = 8,     // number of taps
    parameter integer N1     = 8,     // coeff bitwidth (signed)
    parameter integer N2     = 16,    // input bitwidth (signed)
    parameter integer N3     = 32,    // accumulator/output bitwidth (signed)
    parameter integer SAMPLES = 100   // number of samples to process (for sample_idx/done)
)(
    input  wire                 clk,
    input  wire                 rst_n,     // active-low reset
    input  wire                 en,        // enable shifting/processing (pulse each sample)
    input  wire signed [N2-1:0] din,
    output reg  signed [N3-1:0] dout,
    output reg         [31:0]   sample_idx, // current sample index (0..SAMPLES-1)
    output reg                  done        // asserted when sample_idx reached SAMPLES-1
);

    // ---------------- coefficients (fixed-point integer form) ----------------
    // Replace these with your actual coefficient integers if needed
    localparam signed [N1-1:0] B0 = 8'b00010000;
    localparam signed [N1-1:0] B1 = 8'b00010000;
    localparam signed [N1-1:0] B2 = 8'b00010000;
    localparam signed [N1-1:0] B3 = 8'b00010000;
    localparam signed [N1-1:0] B4 = 8'b00010000;
    localparam signed [N1-1:0] B5 = 8'b00010000;
    localparam signed [N1-1:0] B6 = 8'b00010000;
    localparam signed [N1-1:0] B7 = 8'b00010000;

    // Pack into an array-like wire vector for easier indexing
    wire signed [N1-1:0] b_vec [0:TAP-1];
    assign b_vec[0] = B0; assign b_vec[1] = B1; assign b_vec[2] = B2; assign b_vec[3] = B3;
    assign b_vec[4] = B4; assign b_vec[5] = B5; assign b_vec[6] = B6; assign b_vec[7] = B7;

    // ---------------- shift register for past samples ----------------
    reg signed [N2-1:0] samples [0:TAP-1];
    integer i;

    // ---------------- multiply-add accumulator (registered) ----------------
    reg signed [N3-1:0] acc_reg;

    // ---------------- main sequential logic ----------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset everything
            for (i = 0; i < TAP; i = i + 1) begin
                samples[i] <= {N2{1'b0}};
            end
            acc_reg    <= {N3{1'b0}};
            dout       <= {N3{1'b0}};
            sample_idx <= 32'd0;
            done       <= 1'b0;
        end else begin
            if (en) begin
                // shift samples (newest at samples[0])
                samples[0] <= din;
                for (i = 1; i < TAP; i = i + 1) begin
                    samples[i] <= samples[i-1];
                end

                // compute accumulator (unrolled for clarity)
                acc_reg <=
                    $signed(b_vec[0]) * $signed(samples[0]) +
                    $signed(b_vec[1]) * $signed(samples[1]) +
                    $signed(b_vec[2]) * $signed(samples[2]) +
                    $signed(b_vec[3]) * $signed(samples[3]) +
                    $signed(b_vec[4]) * $signed(samples[4]) +
                    $signed(b_vec[5]) * $signed(samples[5]) +
                    $signed(b_vec[6]) * $signed(samples[6]) +
                    $signed(b_vec[7]) * $signed(samples[7]);

                // register the output
                dout <= acc_reg;

                // increment sample counter (saturates at SAMPLES-1)
                if (!done) begin
                    if (sample_idx < (SAMPLES - 1))
                        sample_idx <= sample_idx + 1;
                    else
                        sample_idx <= sample_idx; // hold at final index
                    // assert done when we've reached last sample
                    done <= (sample_idx >= (SAMPLES - 1)) ? 1'b1 : 1'b0;
                end
                // if already done, hold outputs/sample_idx stable
            end else begin
                // if not enabled, hold state (no new sample taken)
                acc_reg <= acc_reg;
                dout    <= dout;
                sample_idx <= sample_idx;
                done <= done;
            end
        end
    end

endmodule
