`timescale 1ns / 1ps

module tb_FIR_filter;

  // parameters
  localparam N2  = 16;
  localparam N3 = 32;

  // signals
  reg clk, rst, enable;
  reg  signed [N2-1:0]  input_data;
  wire signed [N3-1:0] output_data;
  wire signed [N2-1:0]  sampleT;

  // DUT instantiation
  FIR_filter #(
    .N1(8),
    .N2(N2),
    .N3(N3)
  ) uut (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .input_data(input_data),
    .output_data(output_data),
    .sampleT(sampleT)
  );

  // clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock
  end

  // stimulus
  integer infile, outfile;

    initial begin
    rst = 1; enable = 0; input_data = 0;
    #20 rst = 0; enable = 1;

    // open files
    infile  = $fopen("C:/ABHISHEK/python project folder/input.data", "r");
    outfile = $fopen("C:/ABHISHEK/python project folder/output.data.txt", "w");

    if (infile == 0) begin
      $display("ERROR: input.data file not found!");
      $finish;
    end
    if (outfile == 0) begin
      $display("ERROR: output.data.txt file could not be opened!");
      $finish;
    end

    // read input line by line
    while (!$feof(infile)) begin
      if ($fscanf(infile, "%b\n", input_data) == 1) begin
        @(posedge clk);
        #1; // let output_data settle
        $fwrite(outfile, "%b\n", output_data);
        $fflush(outfile); // force flush
        $display("Input=%b Output=%b", input_data, output_data);
      end
    end

    $fclose(infile);
    $fclose(outfile);
    $display("Simulation finished, output written to output.data.txt");
    $stop;
  end


endmodule
