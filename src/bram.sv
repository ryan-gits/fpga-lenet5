module bram #(parameter int WIDTH = 32,
              parameter int DEPTH = 256) (
  input  logic                     clock,
  input  logic                     we,
  input  logic [$clog2(DEPTH)-1:0] waddr,
  input  logic [WIDTH-1:0]         wdata,
  input  logic [$clog2(DEPTH)-1:0] raddr,
  output logic [WIDTH-1:0]         rdata
);

  logic [$clog2(DEPTH)-1:0] [WIDTH-1:0] mem = '{default:'0};

  always_ff @(posedge clock) begin
    if (we) begin
      mem[waddr] <= wdata;
    end

    rdata <= mem[raddr];
  end

endmodule