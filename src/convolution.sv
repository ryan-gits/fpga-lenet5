`include "axis_if.sv"

module convolution #(parameter int KERNEL_SIZE = 5) (
  input logic                                    clock,
  input logic                                    reset,
  input logic                                    k_coeffs_valid,
  input logic [KERNEL_SIZE*KERNEL_SIZE-1:0][7:0] k_coeffs,       // kernel coefficients
  axis_if.peripheral                             image_in,
  axis_if.main                                   image_out
);
  
  localparam int LINE_BUFFER_DEPTH = 32;
  localparam int LINE_BUFFER_WIDTH = 8;

  // line buffer control / addr signals
  logic [3:0] lb_we;
  logic [$clog2(LINE_BUFFER_DEPTH)-1:0] lb_waddr;
  logic [$clog2(LINE_BUFFER_DEPTH)-1:0] lb_raddr;
  logic [3:0] [LINE_BUFFER_WIDTH-1:0] lb_rdata;

  logic [1:0] lb_wr_ptr;
  logic [1:0] lb_rd_ptr;

  // axi stream control signaling
  logic sof;
  logic eof;
  
  assign sof  = image_in.tready & image_in.tvalid & iamge_in.tuser;
  assign eol  = image_in.tready & image_in.tvalid & image_in.tlast;
  assign dvld = image_in.tready & image_in.tvalid;

  // line buffer write address and buffer pointer logic
  always_ff @(posedge clock) begin
    if (reset) begin
      lb_wr_ptr <= 0;
      lb_waddr  <= 0;
    end else begin
      if (sof) begin
        lb_wr_ptr <= 0;
      end else if (eol) begin
        if (lb_wr_ptr < KERNEL_SIZE-2) begin
          lb_wr_ptr <= lb_wr_ptr + 1'b1;
        end else begin
          lb_wr_ptr <= 0;
        end
      end

      if (eol) begin
        lb_waddr <= 0;
      end else if (dvld) begin
        lb_waddr <= lb_waddr + 1'b1;
      end
    end
  end

  // write enable mux
  always_comb begin
    lb_we = '0;

    lb_we[lb_wr_ptr] = dvld;
  end

  // todo: wdata isn't being registered prior to bram - potential crit path
  for (genvar i=0; i<4; i++) begin
    bram #(.WIDTH(8), .DEPTH(LINE_BUFFER_DEPTH)) U_BRAM_LINE_BUFFER (
      .clock (clock),
      .we    (lb_we[i]),
      .waddr (lb_waddr),
      .wdata (image_in.tdata),
      .raddr (lb_raddr),
      .rdata (lb_rdata[i])
    );
  end

endmodule